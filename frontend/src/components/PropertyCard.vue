<template>
  <q-card class="property-card" @click="$emit('click')">
    <img :src="mainImage" ratio="16/9" class="img-card-property" />

    <!-- <q-img :src="mainImage" ratio="16/9">
      <template #error>
        <div class="column flex flex-center bg-grey-3 text-grey-7">Sem imagem</div>
      </template>
    </q-img> -->

    <q-card-section>
      <div class="text-subtitle1 text-weight-bold ellipsis-2-lines">
        {{ property.title }}
      </div>
      <div class="text-caption text-grey-7 ellipsis-1-line">
        {{ property.city }} - {{ property.state }}
      </div>
      <div class="text-body1 text-weight-bold text-primary q-mt-sm">
        <span v-if="property.transaction_type === 'VENDA' || property.transaction_type === 'AMBOS'">
          {{ formatPrice(property.price) }}
        </span>
        <span
          v-if="property.transaction_type === 'ALUGUEL' || property.transaction_type === 'AMBOS'"
        >
          <span v-if="property.transaction_type === 'AMBOS'" class="q-mx-xs"> / </span>
          {{ formatPrice(property.price) }} / mês
        </span>
      </div>
    </q-card-section>

    <q-card-section class="q-pt-none">
      <div class="row items-center q-gutter-x-md text-grey-7">
        <div v-if="property.bedrooms">
          <q-icon name="king_bed" size="16px" /> {{ property.bedrooms }}
        </div>
        <div v-if="property.bathrooms">
          <q-icon name="bathtub" size="16px" /> {{ property.bathrooms }}
        </div>
        <div v-if="property.area">
          <q-icon name="square_foot" size="16px" /> {{ property.area }} m²
        </div>
      </div>
    </q-card-section>
  </q-card>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import type { Property } from 'src/stores/property'; // Certifique-se de que este path está correto

interface Props {
  property: Property;
}

const props = defineProps<Props>();

// Base URL para imagens, obtida das variáveis de ambiente do Vite
const imageBaseUrl = import.meta.env.VITE_APP_IMAGE_URL || '';

const mainImage = computed<string>(() => {
  if (props.property.images && props.property.images.length > 0) {
    const imageUrl = props.property.images[0].url;
    // Verifica se a URL já está completa (começa com http/https)
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      console.log('Img', imageUrl);
      return imageUrl;
    }
    // Se não estiver completa, prefixa com a base URL
    return `${imageBaseUrl}${imageUrl}`;
  }
  // Imagem placeholder se não houver imagens
  return 'https://via.placeholder.com/400x300?text=Imóvel';
});

const formatPrice = (price: number | null | undefined): string => {
  if (price === null || price === undefined) {
    return 'R$ 0,00';
  }
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL',
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(price);
};
</script>

<style scoped>
.property-card {
  height: 100%;
  cursor: pointer;
  transition:
    transform 0.2s ease-in-out,
    box-shadow 0.2s;
}

.property-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 18px rgba(0, 0, 0, 0.2);
}

.ellipsis-2-lines {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.ellipsis-1-line {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.img-card-property {
  height: 350px !important;
  max-height: 350px !important;
  min-height: 350px !important;
  object-fit: cover;
}
</style>
