<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('property_images', function (Blueprint $table) {
            if (!Schema::hasColumn('property_images', 'path')) {
                $table->string('path')->nullable()->after('url');
            }
            if (!Schema::hasColumn('property_images', 'is_cover')) {
                $table->boolean('is_cover')->default(false)->after('path');
            }
            if (!Schema::hasColumn('property_images', 'order')) {
                $table->integer('order')->unsigned()->default(0)->after('is_cover');
            }
        });
    }

    public function down(): void
    {
        Schema::table('property_images', function (Blueprint $table) {
            $table->dropColumn(array_filter([
                Schema::hasColumn('property_images', 'path')     ? 'path'     : null,
                Schema::hasColumn('property_images', 'is_cover') ? 'is_cover' : null,
                Schema::hasColumn('property_images', 'order')    ? 'order'    : null,
            ]));
        });
    }
};
