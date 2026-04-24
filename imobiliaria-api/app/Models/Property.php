<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Str;

/**
 * @property string $id
 * @property string $title
 * @property string $description
 * @property string $type
 * @property string $status
 * @property numeric $price
 * @property numeric|null $area
 * @property int|null $bedrooms
 * @property int|null $bathrooms
 * @property int|null $garages
 * @property string $address
 * @property string $city
 * @property string $state
 * @property string|null $zip_code
 * @property numeric|null $latitude
 * @property numeric|null $longitude
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @property string $transaction_type
 * @property string|null $neighborhood
 * @property string|null $slug
 * @property bool $featured
 * @property-read \Illuminate\Database\Eloquent\Collection<int, \App\Models\PropertyFeature> $features
 * @property-read int|null $features_count
 * @property-read \Illuminate\Database\Eloquent\Collection<int, \App\Models\PropertyImage> $images
 * @property-read int|null $images_count
 * @property-read \Illuminate\Database\Eloquent\Collection<int, \App\Models\Visit> $visits
 * @property-read int|null $visits_count
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property query()
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereAddress($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereArea($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereBathrooms($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereBedrooms($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereCity($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereCreatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereDescription($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereFeatured($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereGarages($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereLatitude($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereLongitude($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereNeighborhood($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property wherePrice($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereSlug($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereState($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereStatus($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereTitle($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereTransactionType($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereType($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereUpdatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Property whereZipCode($value)
 * @mixin \Eloquent
 */
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
