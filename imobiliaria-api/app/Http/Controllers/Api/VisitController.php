<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Visit;
use Illuminate\Http\Request;

class VisitController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'property_id' => 'required|exists:properties,id',
            'name' => 'required|string|max:255',
            'email' => 'required|email',
            'phone' => 'required|string',
            'date' => 'required|date|after:today',
            'time' => 'required|string',
            'message' => 'nullable|string',
        ]);

        $visit = Visit::create($validated);

        return response()->json([
            'message' => 'Visit scheduled successfully',
            'visit' => $visit,
        ], 201);
    }

    public function index(Request $request)
    {
        $this->middleware('auth:api');
        $this->middleware('admin');

        $visits = Visit::with('property')
            ->when($request->status, function ($query) use ($request) {
                $query->where('status', $request->status);
            })
            ->paginate(20);

        return response()->json($visits);
    }

    public function update(Request $request, Visit $visit)
    {
        $this->middleware('auth:api');
        $this->middleware('admin');

        $validated = $request->validate([
            'status' => 'required|in:PENDENTE,CONFIRMADO,CONCLUIDO,CANCELADO',
        ]);


        $visit->update($validated);

        return response()->json([
            'message' => 'Visita atualizada com sucesso',
            'visit' => $visit,
        ]);
    }
}
