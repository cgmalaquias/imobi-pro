<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('property_images', function (Blueprint $table) {
            // Coluna para o caminho da imagem original (se quiser manter)
            if (!Schema::hasColumn('property_images', 'original_path')) {
                $table->string('original_path')->nullable()->after('path');
            }
            // Coluna para o caminho da imagem otimizada (ex: JPEG de alta qualidade, reduzida)
            if (!Schema::hasColumn('property_images', 'optimized_path')) {
                $table->string('optimized_path')->nullable()->after('original_path');
            }
            // Coluna para o caminho da imagem WebP (formato moderno e mais leve)
            if (!Schema::hasColumn('property_images', 'webp_path')) {
                $table->string('webp_path')->nullable()->after('optimized_path');
            }
            // Coluna para o caminho da thumbnail
            if (!Schema::hasColumn('property_images', 'thumbnail_path')) {
                $table->string('thumbnail_path')->nullable()->after('webp_path');
            }
        });
    }
    public function down(): void
    {
        Schema::table('property_images', function (Blueprint $table) {
            $table->dropColumn(array_filter([
                Schema::hasColumn('property_images', 'original_path')  ? 'original_path'  : null,
                Schema::hasColumn('property_images', 'optimized_path') ? 'optimized_path' : null,
                Schema::hasColumn('property_images', 'webp_path')      ? 'webp_path'      : null,
                Schema::hasColumn('property_images', 'thumbnail_path') ? 'thumbnail_path' : null,
            ]));
        });
    }
};
