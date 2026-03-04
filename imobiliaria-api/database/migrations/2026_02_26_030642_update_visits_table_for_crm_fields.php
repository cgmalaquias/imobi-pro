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
            // Verifique se as colunas existem antes de tentar renomear
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

            // 2. Adicionar novas colunas
            // Adiciona user_id (corretor responsável)
            if (!Schema::hasColumn('visits', 'user_id')) {
                $table->foreignUuid('user_id')->nullable()->constrained('users')->onDelete('set null')->after('message');
            }
            // Adiciona internal_notes (anotações internas)
            if (!Schema::hasColumn('visits', 'internal_notes')) {
                $table->text('internal_notes')->nullable()->after('user_id');
            }

            // 3. Ajustar o status para ser consistente (se necessário)
            // Se você já tem um default 'PENDENTE', não precisa mudar.
            // Se o status for diferente, pode ser necessário um update manual ou um default aqui.
            // $table->string('status')->default('PENDENTE')->change(); // Use ->change() com cuidado
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

            // Remover colunas adicionadas
            if (Schema::hasColumn('visits', 'internal_notes')) {
                $table->dropColumn('internal_notes');
            }
            if (Schema::hasColumn('visits', 'user_id')) {
                $table->dropConstrainedForeignId('user_id'); // Remove a foreign key e a coluna
            }
        });
    }
};
