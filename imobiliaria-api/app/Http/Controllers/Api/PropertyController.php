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
        $query = Property::query();

        // Filtros
        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('city')) {
            $query->where('city', $request->city);
        }

        if ($request->has('minPrice')) {
            $query->where('price', '>=', $request->minPrice);
        }

        if ($request->has('maxPrice')) {
            $query->where('price', '<=', $request->maxPrice);
        }

        if ($request->has('search')) {
            $search = $request->search;
            $query->where('title', 'like', "%$search%")
                ->orWhere('description', 'like', "%$search%")
                ->orWhere('address', 'like', "%$search%");
        }

        $properties = $query->with(['images', 'features'])
            ->paginate(12);

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
            'type' => 'required|in:CASA,APARTAMENTO,COMERCIAL,TERRENO,CHACARA',
            'status' => 'required|in:DISPONIVEL,VENDIDO,ALUGADO',
            'transaction_type' => 'required|in:VENDA,ALUGUEL,TROCA,A COMBINAR',
            'price' => 'required|numeric|min:0',
            'area' => 'nullable|numeric|min:0',
            'bedrooms' => 'nullable|integer|min:0',
            'bathrooms' => 'nullable|integer|min:0',
            'garages' => 'nullable|integer|min:0',
            'address' => 'required|string',
            'city' => 'required|string',
            'state' => 'required|string',
            'zip_code' => 'nullable|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'images' => 'nullable|array',
            'images.*' => 'image|mimes:jpeg,png,jpg,gif|max:5120',
            'features' => 'nullable|array',
            'features.*' => 'string',
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
            'title' => 'string|max:255',
            'description' => 'string',
            'type' => 'in:CASA,APARTAMENTO,COMERCIAL,TERRENO,CHACARA',
            'status' => 'in:DISPONIVEL,VENDIDO,ALUGADO',
            'price' => 'numeric|min:0',
            'area' => 'nullable|numeric|min:0',
            'bedrooms' => 'nullable|integer|min:0',
            'bathrooms' => 'nullable|integer|min:0',
            'garages' => 'nullable|integer|min:0',
            'address' => 'string',
            'city' => 'string',
            'state' => 'string',
            'zip_code' => 'nullable|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'images' => 'nullable|array',
            'images.*' => 'image|mimes:jpeg,png,jpg,gif|max:5120',
            'features' => 'nullable|array',
            'features.*' => 'string',
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
}
