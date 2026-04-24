<?php

namespace App\Http\Controllers;

use App\Models\Property;
use App\Models\PropertyImage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Facades\Image;
use Illuminate\Support\Str;

class PropertyImageController extends Controller
{
    // Reordena as imagens recebendo um array de { id, order }
    public function reorder(Request $request)
    {
        $request->validate([
            'images'          => 'required|array',
            'images.*.id'     => 'required|uuid|exists:property_images,id',
            'images.*.order'  => 'required|integer|min:0',
        ]);

        foreach ($request->images as $item) {
            PropertyImage::where('id', $item['id'])
                ->update(['order' => $item['order']]);
        }

        return response()->json(['message' => 'Ordem atualizada com sucesso.']);
    }

    // Define a imagem de capa (desmarca as outras do mesmo imóvel)
    public function setCover(string $id)
    {
        $image = PropertyImage::findOrFail($id);

        // O booted() do model já cuida de desmarcar as demais
        $image->update(['is_cover' => true]);

        return response()->json(['message' => 'Imagem de capa definida.', 'image' => $image]);
    }

    // Remove uma imagem
    public function destroy(string $id)
    {
        $image = PropertyImage::findOrFail($id);

        // Remove todos os arquivos físicos
        if ($image->original_path && Storage::exists($image->original_path)) {
            Storage::delete($image->original_path);
        }
        if ($image->optimized_path && Storage::exists($image->optimized_path)) {
            Storage::delete($image->optimized_path);
        }
        if ($image->webp_path && Storage::exists($image->webp_path)) {
            Storage::delete($image->webp_path);
        }
        if ($image->thumbnail_path && Storage::exists($image->thumbnail_path)) {
            Storage::delete($image->thumbnail_path);
        }

        // Se era a capa, promove a próxima imagem da fila
        if ($image->is_cover) {
            $next = PropertyImage::where('property_id', $image->property_id)
                ->where('id', '!=', $image->id)
                ->orderBy('order')
                ->first();

            $next?->update(['is_cover' => true]);
        }

        $image->delete();

        return response()->json(['message' => 'Imagem removida.']);
    }

    public function uploadImages(Request $request, string $propertyId)
    {
        $request->validate([
            'images'   => 'required|array',
            'images.*' => 'image|mimes:jpeg,png,jpg,gif,webp|max:10240', // Max 10MB
        ]);

        $property = Property::findOrFail($propertyId);
        $uploadedImages = [];

        foreach ($request->file('images') as $file) {
            $originalName = $file->getClientOriginalName();
            $extension    = $file->getClientOriginalExtension();
            $fileName     = Str::uuid() . '.' . $extension; // Nome único para o arquivo

            // Diretório de armazenamento (ex: public/properties/uuid_do_imovel/)
            $directory = 'properties/' . $property->id;

            // 1. Salvar original (opcional, se quiser manter)
            $originalPath = Storage::putFileAs($directory, $file, 'original_' . $fileName);

            // 2. Processar e salvar versão otimizada (JPEG/PNG)
            $optimizedImage = Image::make($file)
                ->resize(1920, null, function ($constraint) {
                    $constraint->aspectRatio();
                    $constraint->upsize();
                })
                ->encode($extension, 80); // Qualidade 80%
            $optimizedFileName = 'optimized_' . Str::uuid() . '.' . $extension;
            Storage::put($directory . '/' . $optimizedFileName, $optimizedImage->stream());
            $optimizedPath = $directory . '/' . $optimizedFileName;

            // 3. Processar e salvar versão WebP
            $webpImage = Image::make($file)
                ->resize(1920, null, function ($constraint) {
                    $constraint->aspectRatio();
                    $constraint->upsize();
                })
                ->encode('webp', 85); // Qualidade 85% para WebP
            $webpFileName = 'webp_' . Str::uuid() . '.webp';
            Storage::put($directory . '/' . $webpFileName, $webpImage->stream());
            $webpPath = $directory . '/' . $webpFileName;

            // 4. Processar e salvar thumbnail
            $thumbnailImage = Image::make($file)
                ->fit(300, 300) // Corta e redimensiona para 300x300
                ->encode($extension, 70); // Qualidade 70%
            $thumbnailFileName = 'thumb_' . Str::uuid() . '.' . $extension;
            Storage::put($directory . '/' . $thumbnailFileName, $thumbnailImage->stream());
            $thumbnailPath = $directory . '/' . $thumbnailFileName;

            // Criar registro no banco de dados
            $propertyImage = $property->images()->create([
                'url'           => Storage::url($webpPath), // URL principal para o frontend
                'path'          => $optimizedPath, // Manter path para compatibilidade ou usar optimized_path
                'original_path' => $originalPath,
                'optimized_path' => $optimizedPath,
                'webp_path'     => $webpPath,
                'thumbnail_path' => $thumbnailPath,
                'is_cover'      => $property->images()->count() === 0, // Primeira imagem é capa
                'order'         => $property->images()->max('order') + 1,
            ]);
            $uploadedImages[] = $propertyImage;
        }

        return response()->json($uploadedImages, 201);
    }
}
