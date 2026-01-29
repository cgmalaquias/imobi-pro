<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Visit; // Certifique-se de importar o modelo Visit
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator; // Para validação manual, se necessário
use Illuminate\Support\Facades\Auth; // Para acessar o usuário autenticado

class VisitController extends Controller
{
    public function __construct()
    {
        // Aplica o middleware 'auth:jwt' a todas as ações deste controller,
        // exceto 'store' (que é pública para agendamento de cliente).
        // $this->middleware('auth:jwt')->except(['store']); // <-- CORREÇÃO AQUI
    }

    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        // Apenas usuários autenticados podem ver a lista de visitas
        // Você pode adicionar lógica de permissão aqui (ex: apenas ADMIN)
        $visits = Visit::with(['property', 'user'])->get(); // Carrega visitas com dados do imóvel e usuário
        return response()->json($visits);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        // Esta rota é pública para clientes agendarem visitas
        $validator = Validator::make($request->all(), [
            'property_id' => 'required|exists:properties,id',
            'client_name' => 'required|string|max:255',
            'client_email' => 'required|email|max:255',
            'client_phone' => 'required|string|max:20',
            'preferred_date' => 'required|date',
            'preferred_time' => 'required|string|max:5', // Ex: "10:00"
            'message' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $visit = Visit::create([
            'property_id' => $request->property_id,
            'user_id' => Auth::check() ? Auth::id() : null, // Se o cliente estiver logado, associa o ID
            'client_name' => $request->client_name,
            'client_email' => $request->client_email,
            'client_phone' => $request->client_phone,
            'preferred_date' => $request->preferred_date,
            'preferred_time' => $request->preferred_time,
            'status' => 'PENDENTE', // Status inicial da visita
            'message' => $request->message,
        ]);

        return response()->json($visit, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $visit = Visit::with(['property', 'user'])->findOrFail($id);
        return response()->json($visit);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        // Apenas usuários autenticados podem atualizar visitas
        $visit = Visit::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'property_id' => 'required|exists:properties,id',
            'client_name' => 'required|string|max:255',
            'client_email' => 'required|email|max:255',
            'client_phone' => 'required|string|max:20',
            'preferred_date' => 'required|date',
            'preferred_time' => 'required|string|max:5',
            'status' => 'required|in:PENDENTE,CONFIRMADA,CANCELADA,REALIZADA', // Status da visita
            'message' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $visit->update($request->all());

        return response()->json($visit);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        // Apenas usuários autenticados podem deletar visitas
        $visit = Visit::findOrFail($id);
        $visit->delete();

        return response()->json(['message' => 'Visit deleted successfully'], 204);
    }
}
