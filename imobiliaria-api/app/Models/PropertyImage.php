<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @property string $id
 * @property string $property_id
 * @property string $url
 * @property int $order
 * @property \Illuminate\Support\Carbon $created_at
 * @property string|null $path
 * @property bool $is_cover
 * @property string|null $original_path
 * @property string|null $optimized_path
 * @property string|null $webp_path
 * @property string|null $thumbnail_path
 * @property-read \App\Models\Property $property
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyImage newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyImage newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyImage query()
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyImage whereCreatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyImage whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyImage whereIsCover($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyImage whereOptimizedPath($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyImage whereOrder($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyImage whereOriginalPath($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyImage wherePath($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyImage wherePropertyId($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyImage whereThumbnailPath($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyImage whereUrl($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyImage whereWebpPath($value)
 * @mixin \Eloquent
 */
class PropertyImage extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'property_id',
        'url',
        'path',
        'original_path', // Novo
        'optimized_path', // Novo
        'webp_path',      // Novo
        'thumbnail_path', // Novo
        'is_cover',
        'order'
    ];

    protected $casts = [
        'is_cover'   => 'boolean',
        'order'      => 'integer',
        'created_at' => 'datetime',
    ];

    public $timestamps = false;

    public function property(): BelongsTo
    {
        return $this->belongsTo(Property::class);
    }
}
