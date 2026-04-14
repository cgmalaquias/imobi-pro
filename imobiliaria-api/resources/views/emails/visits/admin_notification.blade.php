<x-mail::message>
# Novo Agendamento de Visita Recebido

Um novo agendamento de visita foi realizado através do site.

**Detalhes do Cliente:**
*   **Nome:** {{ $visit->client_name }}
*   **E-mail:** {{ $visit->client_email }}
*   **Telefone:** {{ $visit->client_phone }}
*   **Mensagem:** {{ $visit->message ?? 'Nenhuma mensagem adicional.' }}

**Detalhes da Visita:**
*   **Imóvel:** {{ $visit->property->title }} (ID: {{ $visit->property->id }})
*   **Endereço:** {{ $visit->property->address }}, {{ $visit->property->neighborhood }}, {{ $visit->property->city }} - {{ $visit->property->state }}
*   **Data Desejada:** {{ \Carbon\Carbon::parse($visit->preferred_date)->format('d/m/Y') }}
*   **Horário Desejado:** {{ \Carbon\Carbon::parse($visit->preferred_time)->format('H:i') }}
*   **Status:** {{ $visit->status }}

Por favor, acesse o painel administrativo para gerenciar este agendamento e atribuir um corretor.

<x-mail::button :url="url('/admin/leads/' . $visit->id)">
Ver Detalhes do Agendamento
</x-mail::button>

Atenciosamente,
Sistema ImobiPro
</x-mail::message>
