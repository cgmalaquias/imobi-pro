<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\PropertyController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\VisitController; // Certifique-se de importar o VisitController

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Rotas de Autenticação (públicas, exceto logout e me)
Route::post('auth/register', [AuthController::class, 'register']);
Route::post('auth/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('auth/logout', [AuthController::class, 'logout']);
    Route::get('auth/me', [AuthController::class, 'me']);

    // Rotas de Usuários (apenas para ADMIN)
    Route::apiResource('users', UserController::class)->middleware('can:admin'); // Exemplo de gate/policy

    // Rotas de Imóveis (CRUD completo, exceto index e show que são públicas)
    Route::post('properties/{property}/images/{imageId}', [PropertyController::class, 'deleteImage']); // Rota para deletar imagem específica
    Route::apiResource('properties', PropertyController::class)->except(['index', 'show']);

    // Rotas de Visitas (CRUD completo, pode ser ajustado para roles específicas)
    Route::apiResource('visits', VisitController::class);
});

// Rotas de Imóveis Públicas (sem autenticação)
Route::get('properties', [PropertyController::class, 'index']);
Route::get('properties/{property}', [PropertyController::class, 'show']);

// Rotas de Visitas Públicas (para agendamento de cliente)
Route::post('visits', [VisitController::class, 'store']); // Cliente pode agendar visita sem login

// Rota para lidar com OPTIONS (CORS)
Route::options('{any}', function () {
    return response()->json(['status' => 'ok'], 200);
})->where('any', '.*');

// Rota para servir arquivos do storage (se necessário)
Route::get('storage/{path}', function ($path) {
    return response()->file(storage_path('app/public/' . $path));
})->where('path', '.*');
