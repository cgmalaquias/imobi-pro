<x-mail::message>
# Confirmação de Agendamento de Visita

Olá {{ $visit->client_name }},

Agradecemos o seu interesse! Confirmamos o agendamento da sua visita para o imóvel **{{ $visit->property->title }}**.

**Detalhes da Visita:**
*   **Imóvel:** {{ $visit->property->title }}
*   **Endereço:** {{ $visit->property->address }}, {{ $visit->property->neighborhood }}, {{ $visit->property->city }} - {{ $visit->property->state }}
*   **Data Desejada:** {{ \Carbon\Carbon::parse($visit->preferred_date)->format('d/m/Y') }}
*   **Horário Desejado:** {{ \Carbon\Carbon::parse($visit->preferred_time)->format('H:i') }}
*   **Seu Telefone:** {{ $visit->client_phone }}
*   **Sua Mensagem:** {{ $visit->message ?? 'Nenhuma mensagem adicional.' }}

Em breve, um de nossos corretores entrará em contato para confirmar os detalhes e a disponibilidade.

Se precisar reagendar ou tiver alguma dúvida, por favor, entre em contato conosco.

<x-mail::button :url="url('/imovel/' . $visit->property->id)">
Ver Detalhes do Imóvel
</x-mail::button>

Atenciosamente,
Equipe ImobiPro
</x-mail::message>
