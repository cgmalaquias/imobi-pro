<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('properties', function (Blueprint $table) {
            // ✅ uuid funciona no MySQL, mas precisa ser char(36)
            $table->uuid('id')->primary();
            $table->string('title');
            $table->text('description');

            // ✅ MySQL não tem enum nativo via string com default, mas funciona assim
            $table->enum('type', ['CASA', 'APARTAMENTO', 'COMERCIAL', 'TERRENO', 'CHACARA'])
                ->default('CASA');

            $table->enum('status', ['DISPONIVEL', 'VENDIDO', 'ALUGADO'])
                ->default('DISPONIVEL');

            $table->enum('transaction_type', ['VENDA', 'ALUGUEL', 'AMBOS'])
                ->default('VENDA');

            $table->decimal('price', 12, 2);
            $table->decimal('area', 10, 2)->nullable();
            $table->integer('bedrooms')->unsigned()->nullable();
            $table->integer('bathrooms')->unsigned()->nullable();
            $table->integer('garages')->unsigned()->nullable();

            $table->string('address');
            $table->string('neighborhood')->nullable(); // bairro
            $table->string('city');
            $table->string('state', 2);               // ✅ limitado a UF (ex: PR, SP)
            $table->string('zip_code', 9)->nullable(); // ✅ limitado ao formato CEP

            // ✅ MySQL aceita decimal normalmente para coordenadas
            $table->decimal('latitude', 10, 8)->nullable();
            $table->decimal('longitude', 11, 8)->nullable();

            $table->boolean('featured')->default(false);
            $table->string('slug')->unique()->nullable();

            // ✅ timestamps() funciona igual no MySQL
            $table->timestamps();
            $table->softDeletes(); // opcional, mas recomendado
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('properties');
    }
};
