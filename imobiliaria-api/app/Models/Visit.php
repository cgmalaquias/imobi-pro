<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Visit extends Model
{
    use HasFactory, HasUuids;

    // Constantes para status em português
    const STATUS_PENDENTE = 'PENDENTE';
    const STATUS_CONFIRMADO = 'CONFIRMADO';
    const STATUS_CONCLUIDO = 'CONCLUIDO';
    const STATUS_CANCELADO = 'CANCELADO';

    protected $fillable = [
        'property_id',
        'name',
        'email',
        'phone',
        'date',
        'time',
        'message',
        'status',
    ];

    protected $casts = [
        'date' => 'date',
    ];

    public function property(): BelongsTo
    {
        return $this->belongsTo(Property::class);
    }

    public static function getStatuses(): array
    {
        return [
            self::STATUS_PENDENTE,
            self::STATUS_CONFIRMADO,
            self::STATUS_CONCLUIDO,
            self::STATUS_CANCELADO,
        ];
    }
}
