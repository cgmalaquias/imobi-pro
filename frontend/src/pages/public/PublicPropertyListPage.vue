<template>
  <q-page class="q-pa-md">
    <div class="row items-center q-mb-md">
      <div class="text-h4">Encontre seu Imóvel Ideal</div>
    </div>

    <!-- Filtros e Busca -->
    <q-card flat bordered class="q-mb-md">
      <q-card-section>
        <div class="row q-col-gutter-md">
          <div class="col-12 col-md-3">
            <q-select
              v-model="filters.type"
              :options="propertyTypesOptions"
              label="Tipo de Imóvel"
              outlined
              dense
              clearable
              emit-value
              map-options
              @update:model-value="applyFilters"
            />
          </div>
          <div class="col-12 col-md-3">
            <q-input
              v-model="filters.city"
              label="Cidade"
              outlined
              dense
              clearable
              @update:model-value="applyFilters"
            />
          </div>
          <div class="col-12 col-md-3">
            <q-select
              v-model="filters.transactionType"
              :options="transactionTypesOptions"
              label="Venda/Aluguel"
              outlined
              dense
              clearable
              emit-value
              map-options
              @update:model-value="applyFilters"
            />
          </div>
          <div class="col-12 col-md-3">
            <q-input
              v-model="filters.search"
              label="Buscar"
              outlined
              dense
              clearable
              debounce="500"
              @update:model-value="applyFilters"
            >
              <template v-slot:append>
                <q-icon name="search" />
              </template>
            </q-input>
          </div>
        </div>
      </q-card-section>
    </q-card>

    <!-- Lista de Imóveis -->
    <q-inner-loading :showing="propertyStore.loading">
      <q-spinner-gears size="50px" color="primary" />
    </q-inner-loading>

    <div
      v-if="!propertyStore.loading && propertyStore.properties.length === 0"
      class="text-center q-mt-xl text-grey-7"
    >
      <q-icon name="sentiment_dissatisfied" size="xl" />
      <div class="text-h6 q-mt-sm">Nenhum imóvel encontrado.</div>
    </div>

    <div v-else class="row q-col-gutter-md">
      <div
        v-for="property in propertyStore.properties"
        :key="property.id"
        class="col-12 col-sm-6 col-md-4 col-lg-3"
      >
        <q-card class="property-card cursor-pointer" @click="viewPropertyDetails(property.id)">
          <q-img
            :src="
              property.images && property.images.length > 0
                ? property.images[0].url
                : 'https://via.placeholder.com/400x300?text=Sem+Imagem'
            "
            ratio="16/9"
          />

          <q-card-section>
            <div class="text-h6 q-mb-sm ellipsis-2-lines">{{ property.title }}</div>
            <div class="text-subtitle2 text-grey-8 ellipsis-1-line">
              {{ property.city }} - {{ property.state }}
            </div>
            <div class="text-body1 text-weight-bold text-primary q-mt-sm">
              <span
                v-if="property.transactionType === 'VENDA' || property.transactionType === 'AMBOS'"
              >
                R$ {{ formatPrice(property.priceSale) }}
              </span>
              <span
                v-if="
                  property.transactionType === 'ALUGUEL' || property.transactionType === 'AMBOS'
                "
              >
                <span v-if="property.transactionType === 'AMBOS'"> / </span>
                R$ {{ formatPrice(property.priceRent) }} / mês
              </span>
            </div>
          </q-card-section>

          <q-card-section class="q-pt-none">
            <div class="row items-center q-gutter-x-md text-grey-7">
              <div v-if="property.bedrooms"><q-icon name="king_bed" /> {{ property.bedrooms }}</div>
              <div v-if="property.bathrooms">
                <q-icon name="bathtub" /> {{ property.bathrooms }}
              </div>
              <div v-if="property.areaBuilt">
                <q-icon name="square_foot" /> {{ property.areaBuilt }} m²
              </div>
            </div>
          </q-card-section>

          <q-card-actions align="right">
            <q-btn
              flat
              label="Ver Detalhes"
              color="primary"
              @click.stop="viewPropertyDetails(property.id)"
            />
          </q-card-actions>
        </q-card>
      </div>
    </div>

    <!-- Paginação -->
    <div v-if="propertyStore.totalPages > 1" class="q-mt-md row justify-center">
      <q-pagination
        v-model="pagination.page"
        :max="propertyStore.totalPages"
        :max-pages="5"
        direction-links
        boundary-links
        @update:model-value="changePage"
      />
    </div>
  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { usePropertyStore, PropertyType, PropertyFilters } from 'src/stores/property';

interface SelectOption {
  label: string;
  value: string;
}

const router = useRouter();
const propertyStore = usePropertyStore();

const filters = ref<PropertyFilters>({
  page: 1,
  limit: 12,
  type: undefined,
  city: undefined,
  status: 'DISPONIVEL', // Apenas imóveis disponíveis no site público
  featured: undefined,
  search: undefined,
});

const pagination = ref({
  page: 1,
});

const propertyTypesOptions: SelectOption[] = [
  { label: 'Casa', value: 'CASA' },
  { label: 'Apartamento', value: 'APARTAMENTO' },
  { label: 'Terreno', value: 'TERRENO' },
  { label: 'Comercial', value: 'COMERCIAL' },
  { label: 'Rural', value: 'RURAL' },
];

const transactionTypesOptions: SelectOption[] = [
  { label: 'Venda', value: 'VENDA' },
  { label: 'Aluguel', value: 'ALUGUEL' },
  { label: 'Ambos', value: 'AMBOS' },
];

const loadProperties = async (): Promise<void> => {
  await propertyStore.fetchProperties(filters.value);
  pagination.value.page = propertyStore.page;
};

const applyFilters = (): void => {
  filters.value.page = 1;
  pagination.value.page = 1;
  loadProperties();
};

const changePage = (newPage: number): void => {
  filters.value.page = newPage;
  loadProperties();
};

const viewPropertyDetails = (id: string): void => {
  router.push({ name: 'public-property-details', params: { id } });
};

const formatPrice = (price: number | undefined): string => {
  if (!price) return '0,00';
  return price.toLocaleString('pt-BR', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  });
};

onMounted(async () => {
  await loadProperties();
});
</script>

<style scoped>
.property-card {
  height: 100%;
  display: flex;
  flex-direction: column;
  transition: transform 0.2s ease-in-out;
}

.property-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
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
