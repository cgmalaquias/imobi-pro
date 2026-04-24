<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('property_images', function (Blueprint $table) {
            $table->uuid('id')->primary();

            // ✅ foreignUuid funciona no MySQL, mas precisa que a tabela properties
            // já exista e que o id dela seja char(36)
            $table->uuid('property_id');
            $table->foreign('property_id')
                ->references('id')
                ->on('properties')
                ->onDelete('cascade');

            $table->string('url');         // caminho do arquivo no storage
            $table->string('path')->nullable(); // ✅ adicionado: caminho físico separado da URL
            $table->boolean('is_cover')->default(false); // ✅ destaque de capa
            $table->integer('order')->unsigned()->default(0);

            // ✅ MySQL aceita useCurrent() normalmente
            $table->timestamp('created_at')->useCurrent();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('property_images');
    }
};
