<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @property string $id
 * @property string $property_id
 * @property string $name
 * @property-read \App\Models\Property $property
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyFeature newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyFeature newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyFeature query()
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyFeature whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyFeature whereName($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|PropertyFeature wherePropertyId($value)
 * @mixin \Eloquent
 */
class PropertyFeature extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'property_id',
        'name',
    ];

    public $timestamps = false;

    public function property(): BelongsTo
    {
        return $this->belongsTo(Property::class);
    }
}
