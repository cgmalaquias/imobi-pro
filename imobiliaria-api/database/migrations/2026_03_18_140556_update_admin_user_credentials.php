<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

return new class extends Migration
{
    public function up(): void
    {
        DB::table('users')
            ->where('email', 'contato@karinacarvalhoimoveis.com') // ← identifica o usuário
            ->update([
                'name'     => 'Karina Carvalho',
                'password' => Hash::make(env('ADMIN_INITIAL_PASSWORD')), // ← coloque a senha aqui
                'updated_at' => now(),
            ]);
    }

    public function down(): void
    {
        // Opcional: reverter para os dados anteriores
    }
};
