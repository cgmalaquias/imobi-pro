<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('properties', function (Blueprint $table) {
            // Adiciona a coluna 'featured' como booleano, com valor padrão false
            $table->boolean('featured')->default(false)->after('transaction_type');
            // Você pode ajustar 'after' para posicionar a coluna onde preferir
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('properties', function (Blueprint $table) {
            // Remove a coluna 'featured' se a migration for revertida
            $table->dropColumn('featured');
        });
    }
};
