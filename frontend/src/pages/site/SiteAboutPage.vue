<template>
  <q-page class="q-pa-md about-page">
    <div class="about-container">
      <div class="text-overline text-primary q-mb-sm">Sobre Nós</div>

      <div class="text-h4 text-weight-bold q-mb-md">Conheça um pouco sobre a empresa</div>

      <div class="text-body1 q-mb-md">
        Há {{ yearsInMarket }} anos de experiência no mercado imobiliário em Campina Grande do Sul,
        construímos uma trajetória baseada em confiança e dedicação.
      </div>

      <div class="text-body1 q-mb-md">
        Há {{ yearsCompany }} anos iniciamos um novo passo com a
        <span class="text-weight-bold">empresa Karina Carvalho Imóveis</span>. Abrimos nosso
        escritório para realizar o projeto de cada cliente. Com experiência em imóveis urbanos e
        rurais, atuamos com credibilidade, transparência e alta qualidade.
      </div>

      <div class="text-body1 q-mb-xl">
        Realizar sonhos faz parte da nossa história. Ser reconhecida e indicada pelo ótimo trabalho
        é a nossa maior inspiração!
      </div>

      <q-card flat bordered class="q-pa-md about-highlight">
        <div class="text-subtitle1 text-weight-bold q-mb-xs">Nosso compromisso</div>
        <div class="text-body2">
          Atendemos cada cliente de forma personalizada, entendendo suas necessidades, respeitando
          seu tempo e buscando sempre as melhores oportunidades no mercado imobiliário de Campina
          Grande do Sul e região.
        </div>
      </q-card>
    </div>
  </q-page>
</template>

<script setup lang="ts">
const currentYear = new Date().getFullYear();

// ajuste os anos abaixo conforme a sua história real
const startMarketYear = 2013; // início no mercado imobiliário
const startCompanyYear = 2020; // abertura da empresa Karina Carvalho Imóveis

const yearsInMarket = currentYear - startMarketYear;
const yearsCompany = currentYear - startCompanyYear;
</script>

<style scoped>
.about-page {
  display: flex;
  justify-content: center;
}

.about-container {
  max-width: 900px;
  width: 100%;
  margin: 0 auto;
}

.about-highlight {
  background: #fafafa;
  border-radius: 8px;
}
</style>
