<x-mail::message>
# Atualização da Visita

Olá {{ $visit->client_name }},

Houve uma atualização no status da sua visita para o imóvel **{{ $visit->property->title }}**.

**Detalhes da Visita:**
- **Imóvel:** [{{ $visit->property->title }}]({{ env('APP_FRONTEND_URL') }}/imovel/{{ $visit->property->id }})
- **Data Preferida:** {{ \Carbon\Carbon::parse($visit->preferred_date)->format('d/m/Y') }}
- **Hora Preferida:** {{ $visit->preferred_time }}
- **Status Anterior:** {{ $oldStatus }}
- **Novo Status:** **{{ $visit->status }}**

@if($visit->user)
- **Corretor Responsável:** {{ $visit->user->name }} ({{ $visit->user->email }})
@endif

@if($visit->internal_notes)
- **Anotações Internas:** {{ $visit->internal_notes }}
@endif

@if($visit->status === 'CONFIRMADA')
Sua visita foi **CONFIRMADA**! Em breve, o corretor responsável entrará em contato para mais detalhes.
@elseif($visit->status === 'CANCELADA')
Sua visita foi **CANCELADA**. Se precisar reagendar, por favor, entre em contato.
@elseif($visit->status === 'CONCLUIDA')
Sua visita foi **CONCLUÍDA**. Esperamos que tenha sido produtiva!
@else
O status da sua visita foi atualizado.
@endif

Se tiver alguma dúvida, por favor, entre em contato.

Atenciosamente,
Equipe ImobiPro
</x-mail::message>
