<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('visits', function (Blueprint $table) {

            // 1. Renomear colunas existentes
            // ✅ renameColumn funciona no MariaDB a partir da versão 10.5+
            // Se sua versão for anterior, comente os renames e faça manualmente
            if (Schema::hasColumn('visits', 'name')) {
                $table->renameColumn('name', 'client_name');
            }
            if (Schema::hasColumn('visits', 'email')) {
                $table->renameColumn('email', 'client_email');
            }
            if (Schema::hasColumn('visits', 'phone')) {
                $table->renameColumn('phone', 'client_phone');
            }
            if (Schema::hasColumn('visits', 'date')) {
                $table->renameColumn('date', 'preferred_date');
            }
            if (Schema::hasColumn('visits', 'time')) {
                $table->renameColumn('time', 'preferred_time');
            }

            // 2. Adicionar user_id (corretor responsável)
            if (!Schema::hasColumn('visits', 'user_id')) {
                // ✅ No MariaDB, foreignUuid()->constrained() pode ser instável
                // então usamos uuid + foreign explícito igual às outras migrations
                $table->uuid('user_id')->nullable()->after('message');
                $table->foreign('user_id')
                    ->references('id')
                    ->on('users')
                    ->onDelete('set null');
            }

            // 3. Adicionar internal_notes (anotações internas do corretor)
            if (!Schema::hasColumn('visits', 'internal_notes')) {
                $table->text('internal_notes')->nullable()->after('user_id');
            }
        });
    }

    public function down(): void
    {
        Schema::table('visits', function (Blueprint $table) {

            // Reverter renomeações
            if (Schema::hasColumn('visits', 'client_name')) {
                $table->renameColumn('client_name', 'name');
            }
            if (Schema::hasColumn('visits', 'client_email')) {
                $table->renameColumn('client_email', 'email');
            }
            if (Schema::hasColumn('visits', 'client_phone')) {
                $table->renameColumn('client_phone', 'phone');
            }
            if (Schema::hasColumn('visits', 'preferred_date')) {
                $table->renameColumn('preferred_date', 'date');
            }
            if (Schema::hasColumn('visits', 'preferred_time')) {
                $table->renameColumn('preferred_time', 'time');
            }

            // Remover internal_notes
            if (Schema::hasColumn('visits', 'internal_notes')) {
                $table->dropColumn('internal_notes');
            }

            // ✅ No MariaDB, dropConstrainedForeignId() pode falhar para uuid
            // então removemos a foreign key pelo nome e depois a coluna
            if (Schema::hasColumn('visits', 'user_id')) {
                $table->dropForeign(['user_id']);
                $table->dropColumn('user_id');
            }
        });
    }
};
