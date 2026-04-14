<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\PropertyImage;
use App\Models\PropertyFeature;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator; // Para validação manual, se necessário
use Illuminate\Support\Facades\Auth; // Para acessar o usuário autenticado

class PropertyController extends Controller
{
    public function __construct()
    {
        // $this->middleware('auth:jwt')->except(['index', 'show']);
        // $this->middleware('admin')->only(['store', 'update', 'destroy']);
    }

    public function index(Request $request)
    {
        $query = Property::with(['images', 'features']);

        // Filtro por tipo de transação
        // Filtro por tipo de transação
        if ($request->has('transactionType')) {
            $transactionType = $request->input('transactionType');

            // Aplica o filtro se não for 'AMBOS' ou se 'AMBOS' não for um valor válido para filtro
            // Pelo que entendi, 'AMBOS' não é um valor que existe no campo transaction_type do BD,
            // mas sim uma opção de filtro no frontend para "não filtrar por tipo de transação".
            // Se 'AMBOS' for um valor real no BD, a lógica precisaria ser diferente.
            // Assumindo que 'ALUGUEL' e 'VENDA' são os valores no BD.
            if ($transactionType !== 'AMBOS') {
                $query->where('transaction_type', $transactionType);
            }
            if ($request->has('featured') && $request->input('featured') === 'true') {
                $query->where('featured', true);
            }
        }
        // Outros filtros (já existentes)
        if ($request->has('type')) {
            $query->where('type', $request->input('type'));
        }
        if ($request->has('city')) {
            $query->where('city', 'ilike', '%' . $request->input('city') . '%');
        }
        if ($request->has('status')) {
            $query->where('status', $request->input('status'));
        }
        if ($request->has('featured') && $request->input('featured') === 'true') {
            $query->where('featured', true);
        }
        if ($request->has('search')) {
            $search = $request->input('search');
            $query->where(function ($q) use ($search) {
                $q->where('title', 'ilike', '%' . $search . '%')
                    ->orWhere('description', 'ilike', '%' . $search . '%')
                    ->orWhere('address', 'ilike', '%' . $search . '%')
                    ->orWhere('neighborhood', 'ilike', '%' . $search . '%');
            });
        }
        if ($request->has('minPrice')) {
            $query->where('price', '>=', $request->input('minPrice'));
        }
        if ($request->has('maxPrice')) {
            $query->where('price', '<=', $request->input('maxPrice'));
        }

        $properties = $query->paginate($request->input('limit', 12));

        return response()->json($properties);
    }

    public function show(Property $property)
    {
        $property->load(['images', 'features', 'visits']);

        return response()->json($property);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            // CORREÇÃO 1: 'type' - Verifique os valores exatos que você está enviando do frontend
            'type' => 'required|string|in:CASA,APARTAMENTO,COMERCIAL,TERRENO,FAZENDA',
            'status' => 'required|string|in:DISPONIVEL,VENDIDO,ALUGADO',
            // CORREÇÃO 2: 'transaction_type' - Adicionado 'required' e os valores corretos
            'transaction_type' => 'required|string|in:VENDA,ALUGUEL,TROCA,A COMBINAR',
            'price' => 'required|numeric|min:0',
            'area' => 'nullable|numeric|min:0',
            'bedrooms' => 'nullable|integer|min:0',
            'bathrooms' => 'nullable|integer|min:0',
            'garages' => 'nullable|integer|min:0',
            'address' => 'required|string|max:255',
            'neighborhood' => 'nullable|string|max:255',
            'city' => 'required|string|max:255',
            'state' => 'required|string|max:2', // UF tem 2 caracteres
            'zip_code' => 'nullable|string|max:9', // Ex: 81940-110
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            // CORREÇÃO 3: 'images.*' - Regra para múltiplos arquivos de imagem
            'images' => 'nullable|array', // O array de imagens pode ser nulo
            'images.*' => 'image|mimes:jpeg,png,jpg,gif|max:5120', // Cada item do array deve ser uma imagem (max 5MB)
            'features' => 'nullable|array',
            'features.*' => 'string|max:255',
        ]);

        $property = Property::create($validated);

        // Upload de imagens
        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $index => $image) {
                $path = $image->store('properties', 'public');
                PropertyImage::create([
                    'property_id' => $property->id,
                    'url' => '/storage/' . $path,
                    'order' => $index,
                ]);
            }
        }

        // Adicionar features
        if (isset($validated['features'])) {
            foreach ($validated['features'] as $feature) {
                PropertyFeature::create([
                    'property_id' => $property->id,
                    'name' => $feature,
                ]);
            }
        }

        return response()->json([
            'message' => 'Property created successfully',
            'property' => $property->load(['images', 'features']),
        ], 201);
    }

    public function update(Request $request, Property $property)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'type' => 'required|string|in:CASA,APARTAMENTO,COMERCIAL,TERRENO,FAZENDA',
            'status' => 'required|string|in:DISPONIVEL,VENDIDO,ALUGADO',
            'transaction_type' => 'required|string|in:VENDA,ALUGUEL,TROCA,A COMBINAR',
            'price' => 'required|numeric|min:0',
            'area' => 'nullable|numeric|min:0',
            'bedrooms' => 'nullable|integer|min:0',
            'bathrooms' => 'nullable|integer|min:0',
            'garages' => 'nullable|integer|min:0',
            'address' => 'required|string|max:255',
            'neighborhood' => 'nullable|string|max:255',
            'city' => 'required|string|max:255',
            'state' => 'required|string|max:2',
            'zip_code' => 'nullable|string|max:9',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'images' => 'nullable|array',
            'images.*' => 'image|mimes:jpeg,png,jpg,gif,webp|max:5120',
            'features' => 'nullable|array',
            'features.*' => 'string|max:255',
        ]);

        $property->update($validated);

        // Atualizar imagens
        if ($request->hasFile('images')) {
            $property->images()->delete();
            foreach ($request->file('images') as $index => $image) {
                $path = $image->store('properties', 'public');
                PropertyImage::create([
                    'property_id' => $property->id,
                    'url' => '/storage/' . $path,
                    'order' => $index,
                ]);
            }
        }

        // Atualizar features
        if (isset($validated['features'])) {
            $property->features()->delete();
            foreach ($validated['features'] as $feature) {
                PropertyFeature::create([
                    'property_id' => $property->id,
                    'name' => $feature,
                ]);
            }
        }

        return response()->json([
            'message' => 'Property updated successfully',
            'property' => $property->load(['images', 'features']),
        ]);
    }

    public function destroy(Property $property)
    {
        // Deletar imagens do storage
        foreach ($property->images as $image) {
            Storage::disk('public')->delete(str_replace('/storage/', '', $image->url));
        }

        $property->delete();

        return response()->json(['message' => 'Property deleted successfully']);
    }

    public function showBySlug(string $slug)
    {
        $property = Property::with('images', 'features')
            ->where('slug', $slug)
            ->firstOrFail();

        return response()->json($property);
    }
}
