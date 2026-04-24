<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // ✅ Só adiciona se ainda não existir
        if (!Schema::hasColumn('properties', 'neighborhood')) {
            Schema::table('properties', function (Blueprint $table) {
                $table->string('neighborhood')->nullable()->after('address');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('properties', 'neighborhood')) {
            Schema::table('properties', function (Blueprint $table) {
                $table->dropColumn('neighborhood');
            });
        }
    }
};
