<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @property string $id
 * @property string $property_id
 * @property string $client_name
 * @property string $client_email
 * @property string $client_phone
 * @property \Illuminate\Support\Carbon $preferred_date
 * @property string $preferred_time
 * @property string|null $message
 * @property string $status
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @property string|null $user_id
 * @property string|null $internal_notes
 * @property-read \App\Models\Property $property
 * @property-read \App\Models\User|null $user
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit query()
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit whereClientEmail($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit whereClientName($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit whereClientPhone($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit whereCreatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit whereInternalNotes($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit whereMessage($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit wherePreferredDate($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit wherePreferredTime($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit wherePropertyId($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit whereStatus($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit whereUpdatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder<static>|Visit whereUserId($value)
 * @mixin \Eloquent
 */
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
        'client_name',
        'client_email',
        'client_phone',
        'preferred_date',
        'preferred_time',
        'message',
        'user_id', // Adicionado
        'internal_notes', // Adicionado
        'status',
    ];

    protected $casts = [
        'preferred_date' => 'date',
    ];

    public function property(): BelongsTo
    {
        return $this->belongsTo(Property::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
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
