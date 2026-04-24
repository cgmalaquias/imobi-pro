<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('property_features', function (Blueprint $table) {
            $table->uuid('id')->primary();

            // ✅ Mesma abordagem da property_images: foreign explícito para MariaDB
            $table->uuid('property_id');
            $table->foreign('property_id')
                ->references('id')
                ->on('properties')
                ->onDelete('cascade');

            $table->string('name');        // ex: "Piscina", "Churrasqueira", "Academia"
            $table->string('icon')->nullable(); // ✅ ícone opcional (ex: "pool", "outdoor_grill")

            // ✅ Sem timestamps aqui é válido, feature é simples
            // mas se quiser rastrear quando foi adicionada:
            $table->timestamp('created_at')->useCurrent();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('property_features');
    }
};
