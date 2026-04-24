<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasColumn('properties', 'slug')) {
            Schema::table('properties', function (Blueprint $table) {
                // ✅ string + unique + nullable funciona normalmente no MySQL/MariaDB
                // ✅ ->after() é nativo do MySQL, sem nenhum problema
                $table->string('slug')->unique()->nullable()->after('title');
            });
        }
    }

    public function down(): void
    {
        Schema::table('properties', function (Blueprint $table) {
            // ✅ Corrigido: down() estava vazio na migration original
            // No MySQL precisamos dropar o índice unique antes de dropar a coluna
            $table->dropUnique(['slug']);
            $table->dropColumn('slug');
        });
    }
};
