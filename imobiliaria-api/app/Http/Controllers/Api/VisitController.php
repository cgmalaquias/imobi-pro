<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Visit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth; // Importar Auth para o middleware

class VisitController extends Controller
{
    public function __construct()
    {
        // Aplica o middleware 'auth:api' a todas as ações deste controller,
        // exceto 'store' (que é pública para agendamento de cliente).
        // Se você estiver usando 'auth:jwt' no seu projeto, use 'auth:jwt' aqui.
        $this->middleware('auth:api')->except(['store']);
    }

    /**
     * Lista visitas (para o admin).
     * Aceita filtros simples por status e busca pelo nome/email/telefone.
     */
    public function index(Request $request)
    {
        // O usuário autenticado agora pode acessar esta rota
        $query = Visit::with('property');

        if ($status = $request->query('status')) {
            $query->where('status', $status);
        }

        if ($search = $request->query('search')) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%")
                    ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        $perPage = (int) $request->query('per_page', 15);

        $visits = $query->orderByDesc('date')
            ->orderByDesc('time')
            ->paginate($perPage);

        return response()->json($visits);
    }

    /**
     * Cadastra uma nova visita (lead) – rota pública, chamada pelo site.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'property_id' => ['required', 'exists:properties,id'],
            'name'        => ['required', 'string', 'max:255'],
            'email'       => ['required', 'email', 'max:255'],
            'phone'       => ['required', 'string', 'max:20'],
            'date'        => ['required', 'date'],
            'time'        => ['required', 'string', 'max:5'], // Ex: "14:30"
            'message'     => ['nullable', 'string'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Dados de agendamento inválidos.', 'errors' => $validator->errors()], 422);
        }

        $visit = Visit::create([
            'property_id'   => $request->property_id,
            'client_name'   => $request->client_name,
            'client_email'  => $request->client_email,
            'client_phone'  => $request->client_phone,
            'preferred_date' => $request->date,
            'preferred_time' => $request->time,
            'message'       => $request->message,
            'status'        => 'PENDENTE', // Status inicial
        ]);

        return response()->json($visit, 201);
    }

    /**
     * Exibe uma visita específica (para o admin).
     */
    public function show(Visit $visit)
    {
        // O usuário autenticado agora pode acessar esta rota
        return response()->json($visit->load('property'));
    }

    /**
     * Atualiza o status de uma visita (para o admin).
     */
    public function update(Request $request, Visit $visit)
    {
        // O usuário autenticado agora pode acessar esta rota
        $validator = Validator::make($request->all(), [
            'status' => ['required', 'string', 'in:PENDENTE,CONFIRMADA,CONCLUIDA,CANCELADA'],
            // Se for adicionar user_id ou internal_notes no futuro, adicione validação aqui
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Dados de atualização inválidos.', 'errors' => $validator->errors()], 422);
        }

        $visit->update([
            'status' => $request->status,
        ]);

        return response()->json($visit);
    }

    /**
     * Remove uma visita (para o admin).
     */
    public function destroy(Visit $visit)
    {
        // O usuário autenticado agora pode acessar esta rota
        $visit->delete();
        return response()->json(null, 204);
    }
}
