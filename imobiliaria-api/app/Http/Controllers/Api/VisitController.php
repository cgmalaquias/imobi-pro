<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Mail\AdminVisitNotificationMail;
use App\Mail\ClientVisitConfirmationMail;
use App\Mail\VisitStatusUpdatedMail;
use App\Models\User;
use App\Models\Visit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth; // Importar Auth para o middleware
use Illuminate\Support\Facades\Mail;

class VisitController extends Controller
{
    public function __construct()
    {
        // Aplica o middleware 'auth:api' a todas as ações deste controller,
        // exceto 'store' (que é pública para agendamento de cliente).
        // Se você estiver usando 'auth:jwt' no seu projeto, use 'auth:jwt' aqui.
        // $this->middleware('auth:api')->except(['store']);
    }

    /**
     * Lista visitas (para o admin).
     * Aceita filtros simples por status e busca pelo nome/email/telefone.
     */
    public function index(Request $request)
    {
        $query = Visit::with(['property', 'user']); // Carrega o imóvel e o corretor responsável

        if ($status = $request->query('status')) {
            $query->where('status', $status);
        }

        if ($search = $request->query('search')) {
            $query->where(function ($q) use ($search) {
                $q->where('client_name', 'like', "%{$search}%")
                    ->orWhere('client_email', 'like', "%{$search}%")
                    ->orWhere('client_phone', 'like', "%{$search}%");
            });
        }

        // Ordenação
        $sortBy = $request->query('sort_by', 'preferred_date'); // Default para preferred_date
        $sortOrder = $request->query('sort_order', 'desc'); // Default para descendente

        // Garante que a coluna de ordenação existe e é permitida
        $allowedSortColumns = ['client_name', 'client_email', 'client_phone', 'preferred_date', 'status', 'created_at'];
        if (!in_array($sortBy, $allowedSortColumns)) {
            $sortBy = 'preferred_date'; // Fallback
        }

        $query->orderBy($sortBy, $sortOrder);

        // Paginação
        $perPage = $request->query('per_page', 10);
        $visits = $query->paginate($perPage);

        return response()->json($visits);
    }

    /**
     * Cadastra uma nova visita (lead) – rota pública, chamada pelo site.
     */
    /**
     * Armazena um novo agendamento de visita (público).
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'property_id'    => ['required', 'exists:properties,id'],
            'client_name'    => ['required', 'string', 'max:255'],
            'client_email'   => ['required', 'email', 'max:255'],
            'client_phone'   => ['required', 'string', 'max:20'],
            'preferred_date' => ['required', 'date'],
            'preferred_time' => ['required', 'date_format:H:i'], // Garante formato HH:MM
            'message'        => ['nullable', 'string'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Dados de agendamento inválidos.', 'errors' => $validator->errors()], 422);
        }

        $visit = Visit::create([
            'property_id'    => $request->property_id,
            'client_name'    => $request->client_name,
            'client_email'   => $request->client_email,
            'client_phone'   => $request->client_phone,
            'preferred_date' => $request->preferred_date,
            'preferred_time' => $request->preferred_time,
            'message'        => $request->message,
            'status'         => 'PENDENTE', // Status inicial
            // user_id e internal_notes são nulos por padrão na criação pública
        ]);

        // Carrega o relacionamento 'property' para os e-mails
        $visit->load('property');

        // 1. Envia e-mail de confirmação para o cliente
        Mail::to($visit->client_email)->send(new ClientVisitConfirmationMail($visit));

        // 2. Envia e-mail de notificação para o administrador
        // Você pode definir um e-mail fixo para o admin ou buscar um usuário admin
        $adminEmail = env('MAIL_ADMIN_ADDRESS', 'mail@karinacarvalhoimoveis.com'); // Use uma variável de ambiente ou um e-mail fixo
        Mail::to($adminEmail)
            ->cc('contato@karinacarvalhoimoveis.com')
            ->bcc('osnaldo.souza@gmail.com')
            ->send(new AdminVisitNotificationMail($visit));

        // Opcional: Se você tiver um corretor específico para o imóvel, pode enviar para ele também.
        // if ($visit->property->user_id) {
        //     $broker = User::find($visit->property->user_id);
        //     if ($broker) {
        //         Mail::to($broker->email)->send(new AdminVisitNotificationMail($visit));
        //     }
        // }


        return response()->json($visit, 201);
    }

    /**
     * Exibe uma visita específica (para o admin).
     */
    public function show(Visit $visit)
    {
        return response()->json($visit->load(['property', 'user'])); // Carrega o imóvel e o corretor
    }

    /**
     * Atualiza o status, corretor e anotações de uma visita (para o admin).
     */
    public function update(Request $request, Visit $visit)
    {
        $validator = Validator::make($request->all(), [
            'status'         => ['required', 'string', 'in:PENDENTE,CONFIRMADA,CONCLUIDA,CANCELADA'],
            'user_id'        => ['nullable', 'uuid', 'exists:users,id'], // Adicionado para permitir atribuição de corretor
            'internal_notes' => ['nullable', 'string'], // Adicionado para permitir anotações
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Dados de atualização inválidos.', 'errors' => $validator->errors()], 422);
        }

        // Guarda o status e user_id antigos para comparação
        $oldStatus = $visit->status;
        $oldUserId = $visit->user_id;

        $visit->update([
            'status'         => $request->status,
            'user_id'        => $request->user_id,
            'internal_notes' => $request->internal_notes,
        ]);

        // Carrega os relacionamentos atualizados para os e-mails
        $visit->load('property', 'user');

        // Lógica de envio de e-mails após a atualização
        $adminEmail = env('MAIL_ADMIN_ADDRESS', 'admin@imobipro.com.br');

        // 1. Notificar o cliente se o status mudou
        if ($visit->status !== $oldStatus) {
            Mail::to($visit->client_email)
                ->cc('contato@karinacarvalhoimoveis.com')
                ->bcc('osnaldo.souza@gmail.com')
                ->send(new VisitStatusUpdatedMail($visit, $oldStatus, $oldUserId));
        }

        // 2. Notificar o novo corretor (se houver e se mudou)
        if ($visit->user_id && $visit->user_id !== $oldUserId) {
            $newBroker = User::find($visit->user_id);
            if ($newBroker) {
                Mail::to($newBroker->email)
                    ->send(new VisitStatusUpdatedMail($visit, $oldStatus, $oldUserId));
            }
        }
        // 3. Opcional: Notificar o admin sobre qualquer mudança (se não for o corretor)
        // Se o admin já recebe notificação por ser o corretor, pode-se evitar duplicidade.
        // Por simplicidade, vamos considerar que o admin pode ser o corretor ou apenas receber uma cópia.
        // Se o admin não for o novo corretor e o status mudou, ele também pode receber.
        // if ($visit->status !== $oldStatus && $visit->user_id !== $adminUser->id) { // Exemplo se você tiver um objeto adminUser
        //     Mail::to($adminEmail)->send(new VisitStatusUpdatedMail($visit, $oldStatus, $oldUserId));
        // }


        return response()->json($visit);
    }

    /**
     * Remove uma visita (para o admin).
     */
    public function destroy(Visit $visit)
    {
        $visit->delete();
        return response()->json(null, 204);
    }
}
