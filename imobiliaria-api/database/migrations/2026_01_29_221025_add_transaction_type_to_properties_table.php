<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // ✅ Só adiciona a coluna se ela ainda não existir
        if (!Schema::hasColumn('properties', 'transaction_type')) {
            Schema::table('properties', function (Blueprint $table) {
                $table->enum('transaction_type', ['VENDA', 'ALUGUEL', 'AMBOS'])
                    ->default('VENDA')
                    ->after('status');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('properties', 'transaction_type')) {
            Schema::table('properties', function (Blueprint $table) {
                $table->dropColumn('transaction_type');
            });
        }
    }
};
