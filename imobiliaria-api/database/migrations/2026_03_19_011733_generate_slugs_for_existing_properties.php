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

        // 3. Adiciona índice único
        // ✅ Substituída a query pg_indexes (exclusiva do PostgreSQL)
        // por INFORMATION_SCHEMA que é compatível com MySQL/MariaDB
        $indexExists = DB::select("
            SELECT INDEX_NAME
            FROM INFORMATION_SCHEMA.STATISTICS
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME   = 'properties'
              AND INDEX_NAME   = 'properties_slug_unique'
        ");

        if (empty($indexExists)) {
            Schema::table('properties', function (Blueprint $table) {
                $table->unique('slug', 'properties_slug_unique');
            });
        }
    }

    public function down(): void
    {
        Schema::table('properties', function (Blueprint $table) {
            // ✅ No MySQL/MariaDB dropUnique recebe o nome do índice como string direta
            $table->dropUnique('properties_slug_unique');
            $table->dropColumn('slug');
        });
    }
};
