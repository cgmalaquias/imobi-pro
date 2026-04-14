<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        // 1. Adiciona coluna slug se não existir
        if (!Schema::hasColumn('properties', 'slug')) {
            Schema::table('properties', function (Blueprint $table) {
                $table->string('slug')->nullable()->after('title');
            });
        }

        // 2. Gera slugs para imóveis que ainda não têm
        $properties = DB::table('properties')
            ->whereNull('slug')
            ->orWhere('slug', '')
            ->get(['id', 'title', 'neighborhood', 'city']);

        foreach ($properties as $property) {
            $base = Str::slug(
                trim("{$property->title} {$property->neighborhood} {$property->city}")
            );

            $slug    = $base;
            $counter = 1;

            while (
                DB::table('properties')
                ->where('slug', $slug)
                ->where('id', '!=', $property->id)
                ->exists()
            ) {
                $slug = "{$base}-{$counter}";
                $counter++;
            }

            DB::table('properties')
                ->where('id', $property->id)
                ->update(['slug' => $slug]);
        }

        // 3. Adiciona índice único — compatível com Laravel 10+ e PostgreSQL
        Schema::table('properties', function (Blueprint $table) {
            // Verifica via query no information_schema (funciona em PostgreSQL e MySQL)
            $indexExists = DB::select("
                SELECT indexname
                FROM pg_indexes
                WHERE tablename = 'properties'
                AND indexname = 'properties_slug_unique'
            ");

            if (empty($indexExists)) {
                $table->unique('slug', 'properties_slug_unique');
            }
        });
    }

    public function down(): void
    {
        Schema::table('properties', function (Blueprint $table) {
            $table->dropUnique('properties_slug_unique');
            $table->dropColumn('slug');
        });
    }
};
