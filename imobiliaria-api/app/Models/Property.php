<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Str;

class Property extends Model
{
    use HasFactory, HasUuids;

    // Constantes para tipos em português
    const TYPE_CASA = 'CASA';
    const TYPE_APARTAMENTO = 'APARTAMENTO';
    const TYPE_COMERCIAL = 'COMERCIAL';
    const TYPE_TERRENO = 'TERRENO';
    const TYPE_CHACARA = 'CHACARA';

    const STATUS_DISPONIVEL = 'DISPONIVEL';
    const STATUS_VENDIDO = 'VENDIDO';
    const STATUS_ALUGADO = 'ALUGADO';

    protected $fillable = [
        'title',
        'slug',
        'description',
        'transaction_type',
        'type',
        'status',
        'price',
        'area',
        'bedrooms',
        'bathrooms',
        'garages',
        'address',
        'neighborhood',
        'city',
        'state',
        'zip_code',
        'latitude',
        'longitude',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'area' => 'decimal:2',
        'latitude' => 'decimal:8',
        'longitude' => 'decimal:8',
        'bedrooms' => 'integer',
        'bathrooms' => 'integer',
        'garages' => 'integer',
    ];

    protected static function booted()
    {
        static::creating(function ($property) {
            if (empty($property->slug)) {
                $property->slug = static::generateSlug($property->title, $property->city, $property->neighborhood);
            }
        });

        static::updating(function ($property) {
            if ($property->isDirty('title') || $property->isDirty('city') || $property->isDirty('neighborhood')) {
                $property->slug = static::generateSlug($property->title, $property->city, $property->neighborhood);
            }
        });
    }

    protected static function generateSlug($title, $city = null, $neighborhood = null)
    {
        $base = trim($title . ' ' . $neighborhood . ' ' . $city);
        $slug = Str::slug($base);

        // Garante unicidade básica
        $count = static::where('slug', 'like', "{$slug}%")->count();
        return $count ? "{$slug}-{$count}" : $slug;
    }
    public function images(): HasMany
    {
        return $this->hasMany(PropertyImage::class)->orderBy('order');
    }

    public function features(): HasMany
    {
        return $this->hasMany(PropertyFeature::class);
    }

    public function visits(): HasMany
    {
        return $this->hasMany(Visit::class);
    }

    // Helper methods
    public static function getTypes(): array
    {
        return [
            self::TYPE_CASA,
            self::TYPE_APARTAMENTO,
            self::TYPE_COMERCIAL,
            self::TYPE_TERRENO,
            self::TYPE_CHACARA,
        ];
    }

    public static function getStatuses(): array
    {
        return [
            self::STATUS_DISPONIVEL,
            self::STATUS_VENDIDO,
            self::STATUS_ALUGADO,
        ];
    }
    public function getTransactionTypeAttribute($value): string
    {
        return strtoupper($value);
    }
}
