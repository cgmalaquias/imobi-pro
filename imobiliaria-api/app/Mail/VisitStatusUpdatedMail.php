<?php

namespace App\Mail;

use App\Models\Visit;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class VisitStatusUpdatedMail extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public Visit $visit;
    public string $oldStatus;
    public ?string $oldUserId; // Pode ser null se não havia corretor antes

    /**
     * Create a new message instance.
     */
    public function __construct(Visit $visit, string $oldStatus, ?string $oldUserId)
    {
        $this->visit = $visit;
        $this->oldStatus = $oldStatus;
        $this->oldUserId = $oldUserId;
    }

    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        // Assunto dinâmico baseado no novo status
        $subject = 'Atualização da sua Visita - ImobiPro: ' . $this->visit->status;
        if ($this->visit->status === 'CONFIRMADA') {
            $subject = 'Visita Confirmada - ImobiPro!';
        } elseif ($this->visit->status === 'CANCELADA') {
            $subject = 'Visita Cancelada - ImobiPro';
        }

        return new Envelope(
            subject: $subject,
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        return new Content(
            markdown: 'emails.visits.status_updated', // Usaremos um template Markdown
            with: [
                'visit' => $this->visit,
                'oldStatus' => $this->oldStatus,
                'oldUserId' => $this->oldUserId,
            ],
        );
    }

    /**
     * Get the attachments for the message.
     *
     * @return array<int, \Illuminate\Mail\Mailables\Attachment>
     */
    public function attachments(): array
    {
        return [];
    }
}
