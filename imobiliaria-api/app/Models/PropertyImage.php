<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PropertyImage extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'property_id',
        'url',
        'order',
    ];

    protected $casts = [
        'order' => 'integer',
    ];

    public $timestamps = false;

    public function property(): BelongsTo
    {
        return $this->belongsTo(Property::class);
    }
}
