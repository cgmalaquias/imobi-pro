<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('visits', function (Blueprint $table) {
            $table->uuid('id')->primary();

            // ✅ Foreign explícito para MariaDB
            $table->uuid('property_id');
            $table->foreign('property_id')
                ->references('id')
                ->on('properties')
                ->onDelete('cascade');

            // Dados do visitante
            $table->string('name');
            $table->string('email');
            $table->string('phone', 20);       // ✅ limitado ao tamanho de telefone

            // Data e hora da visita
            $table->date('date');
            $table->time('time');              // ✅ trocado de string para time nativo do MySQL

            $table->text('message')->nullable();

            // ✅ enum garante integridade dos status no MySQL
            $table->enum('status', ['PENDENTE', 'CONFIRMADO', 'CONCLUIDO', 'CANCELADO'])
                ->default('PENDENTE');

            $table->string('notes')->nullable(); // ✅ observações internas do corretor

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('visits');
    }
};
