<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\PropertyController;
use App\Http\Controllers\Api\VisitController;
use App\Http\Controllers\Api\UserController;

Route::prefix('api')->group(function () {

    // ===== AUTENTICAÇÃO (Público) =====
    Route::post('/auth/register', [AuthController::class, 'register']);
    Route::post('/auth/login', [AuthController::class, 'login']);

    // ===== PROPERTIES (Público - Listagem e Detalhes) =====
    Route::get('/properties', [PropertyController::class, 'index']);
    Route::get('/properties/{property}', [PropertyController::class, 'show']);

    // ===== VISITS (Público - Agendar) =====
    Route::post('/visits', [VisitController::class, 'store']);

    // ===== Rotas Protegidas (Requer JWT) =====
    Route::middleware('auth:api')->group(function () {

        // Autenticação
        Route::post('/auth/logout', [AuthController::class, 'logout']);
        Route::get('/auth/me', [AuthController::class, 'me']);
        Route::post('/auth/refresh', [AuthController::class, 'refresh']);

        // ===== ADMIN - Properties (CRUD) =====
        Route::middleware('admin')->group(function () {
            Route::post('/properties', [PropertyController::class, 'store']);
            Route::put('/properties/{property}', [PropertyController::class, 'update']);
            Route::delete('/properties/{property}', [PropertyController::class, 'destroy']);

            // Visits (Gerenciar)
            Route::get('/visits', [VisitController::class, 'index']);
            Route::put('/visits/{visit}', [VisitController::class, 'update']);

            // Users (Gerenciar)
            Route::get('/users', [UserController::class, 'index']);
            Route::post('/users', [UserController::class, 'store']);
            Route::put('/users/{user}', [UserController::class, 'update']);
            Route::delete('/users/{user}', [UserController::class, 'destroy']);
        });
    });
});
