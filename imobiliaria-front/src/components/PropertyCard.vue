<template>
  <q-card class="property-card" @click="$emit('click')">
    <q-img :src="mainImage" ratio="16/9">
      <template #error>
        <div class="column flex flex-center bg-grey-3 text-grey-7">Sem imagem</div>
      </template>
    </q-img>

    <q-card-section>
      <div class="text-subtitle1 text-weight-bold ellipsis-2-lines">
        {{ property.title }}
      </div>
      <div class="text-caption text-grey-7 ellipsis-1-line">
        {{ property.city }} - {{ property.state }}
      </div>
      <div class="text-body1 text-weight-bold text-primary q-mt-sm">
        <span v-if="property.transactionType === 'VENDA' || property.transactionType === 'AMBOS'">
          R$ {{ formatPrice(property.priceSale) }}
        </span>
        <span v-if="property.transactionType === 'ALUGUEL' || property.transactionType === 'AMBOS'">
          <span v-if="property.transactionType === 'AMBOS'"> / </span>
          R$ {{ formatPrice(property.priceRent) }} / mês
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
        <div v-if="property.areaBuilt">
          <q-icon name="square_foot" size="16px" /> {{ property.areaBuilt }} m²
        </div>
      </div>
    </q-card-section>
  </q-card>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import type { Property } from 'src/stores/property';

interface Props {
  property: Property;
}

const props = defineProps<Props>();

const mainImage = computed<string>(() => {
  if (props.property.images && props.property.images.length > 0) {
    return props.property.images[0].url;
  }
  return 'https://via.placeholder.com/400x300?text=Imóvel';
});

const formatPrice = (price: number | undefined): string => {
  if (!price) return '0,00';
  return price.toLocaleString('pt-BR', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  });
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
</style>
