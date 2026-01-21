<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        User::create([
            'name' => 'Administrador',
            'email' => 'admin@imobiliaria.com',
            'password' => Hash::make('admin123'),
            'role' => 'ADMIN',
            'active' => true,
        ]);

        User::create([
            'name' => 'Usuário Teste',
            'email' => 'usuario@imobiliaria.com',
            'password' => Hash::make('usuario123'),
            'role' => 'USUARIO',
            'active' => true,
        ]);
    }
}
