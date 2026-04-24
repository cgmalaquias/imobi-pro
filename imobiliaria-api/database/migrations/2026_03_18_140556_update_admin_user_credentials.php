<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

return new class extends Migration
{
    public function up(): void
    {
        // ✅ DB::table()->update() funciona igual no MySQL/MariaDB
        DB::table('users')
            ->where('email', 'contato@karinacarvalhoimoveis.com')
            ->update([
                'name'       => 'Karina Carvalho',
                'password'   => Hash::make(env('ADMIN_INITIAL_PASSWORD', 'senha_padrao_temporaria')),
                'updated_at' => now(),
            ]);
    }

    public function down(): void
    {
        // Sem reversão significativa para dados sensíveis como senha
        // mas caso queira invalidar o acesso no rollback:
        // DB::table('users')
        //     ->where('email', 'contato@karinacarvalhoimoveis.com')
        //     ->update(['password' => Hash::make(str()->random(32))]);
    }
};
