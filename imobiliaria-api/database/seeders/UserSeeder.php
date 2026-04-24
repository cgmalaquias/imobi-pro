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
            'name' => 'Karina Carvalho',
            'email' => 'karinacarvalhocorretora@gmail.com',
            'password' => Hash::make('karina@2022*'),
            'role' => 'ADMIN',
            'active' => true,
        ]);

        // User::create([
        //     'name' => 'Usuário Teste',
        //     'email' => 'usuario@imobiliaria.com',
        //     'password' => Hash::make('usuario123'),
        //     'role' => 'USUARIO',
        //     'active' => true,
        // ]);
    }
}
