<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasColumn('properties', 'featured')) {
            Schema::table('properties', function (Blueprint $table) {
                // ✅ boolean() no MySQL/MariaDB é implementado como TINYINT(1)
                // default(false) vira default(0) — funciona perfeitamente
                // ->after() é nativo do MySQL, sem nenhum problema
                $table->boolean('featured')->default(false)->after('transaction_type');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('properties', 'featured')) {
            Schema::table('properties', function (Blueprint $table) {
                $table->dropColumn('featured');
            });
        }
    }
};
