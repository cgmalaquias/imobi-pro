<template>
  <q-page class="q-pa-md">
    <div class="text-h4 q-mb-md">Imóveis Disponíveis</div>

    <!-- Filtros -->
    <q-card class="q-mb-md">
      <q-card-section>
        <div class="row q-col-gutter-md">
          <div class="col-12 col-md-3">
            <q-select
              v-model="filters.type"
              :options="propertyTypes"
              label="Tipo"
              outlined
              dense
              clearable
              @update:model-value="loadProperties"
            />
          </div>

          <div class="col-12 col-md-3">
            <q-input
              v-model="filters.city"
              label="Cidade"
              outlined
              dense
              clearable
              @update:model-value="loadProperties"
            />
          </div>

          <div class="col-12 col-md-3">
            <q-input
              v-model.number="filters.minPrice"
              label="Preço Mínimo"
              type="number"
              outlined
              dense
              clearable
              prefix="R$"
              @update:model-value="loadProperties"
            />
          </div>

          <div class="col-12 col-md-3">
            <q-input
              v-model.number="filters.maxPrice"
              label="Preço Máximo"
              type="number"
              outlined
              dense
              clearable
              prefix="R$"
              @update:model-value="loadProperties"
            />
          </div>

          <div class="col-12">
            <q-input
              v-model="filters.search"
              label="Buscar por título, descrição ou endereço"
              outlined
              dense
              clearable
              @update:model-value="loadProperties"
            >
              <template v-slot:prepend>
                <q-icon name="search" />
              </template>
            </q-input>
          </div>
        </div>
      </q-card-section>
    </q-card>

    <!-- Grid de imóveis -->
    <div v-if="!loading && properties.length > 0" class="row q-col-gutter-md">
      <div v-for="property in properties" :key="property.id" class="col-12 col-sm-6 col-md-4">
        <q-card class="cursor-pointer property-card" @click="viewProperty(property.id)">
          <q-img :src="property.images?.[0]?.url || '/placeholder.jpg'" ratio="16/9">
            <div class="absolute-top-right q-pa-sm">
              <q-badge
                :color="getStatusColor(property.status)"
                :label="getStatusLabel(property.status)"
              />
            </div>
          </q-img>

          <q-card-section>
            <div class="text-h6 ellipsis-2-lines">{{ property.title }}</div>
            <div class="text-subtitle2 text-grey-7 q-mt-xs">
              <q-icon name="place" size="xs" />
              {{ property.city }} - {{ property.state }}
            </div>
            <div class="text-h5 text-primary q-mt-sm">R$ {{ formatPrice(property.price) }}</div>
          </q-card-section>

          <q-card-section class="q-pt-none">
            <div class="row q-gutter-xs">
              <q-chip
                v-if="property.bedrooms"
                dense
                icon="bed"
                size="sm"
                :label="`${property.bedrooms} quartos`"
              />
              <q-chip
                v-if="property.bathrooms"
                dense
                icon="bathroom"
                size="sm"
                :label="`${property.bathrooms} banheiros`"
              />
              <q-chip
                v-if="property.area"
                dense
                icon="straighten"
                size="sm"
                :label="`${property.area} m²`"
              />
            </div>
          </q-card-section>
        </q-card>
      </div>
    </div>

    <!-- Empty state -->
    <div v-if="!loading && properties.length === 0" class="text-center q-pa-xl">
      <q-icon name="home_work" size="80px" color="grey-5" />
      <div class="text-h6 text-grey-7 q-mt-md">Nenhum imóvel encontrado</div>
      <div class="text-body2 text-grey-6">Tente ajustar os filtros de busca</div>
    </div>

    <!-- Paginação -->
    <div class="flex flex-center q-mt-md" v-if="pagination.last_page > 1">
      <q-pagination
        v-model="pagination.current_page"
        :max="pagination.last_page"
        direction-links
        boundary-links
        @update:model-value="loadProperties"
      />
    </div>

    <!-- Loading -->
    <q-inner-loading :showing="loading">
      <q-spinner-gears size="50px" color="primary" />
    </q-inner-loading>
  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import type { Property, PropertyFilters } from 'src/services/property.service';
import { propertyService } from 'src/services/property.service';

const router = useRouter();

const properties = ref<Property[]>([]);
const loading = ref(false);
const filters = ref<PropertyFilters>({
  status: 'DISPONIVEL', // Apenas imóveis disponíveis no site público
});
const pagination = ref({
  current_page: 1,
  last_page: 1,
  per_page: 12,
  total: 0,
});

const propertyTypes = [
  { label: 'Casa', value: 'CASA' },
  { label: 'Apartamento', value: 'APARTAMENTO' },
  { label: 'Comercial', value: 'COMERCIAL' },
  { label: 'Terreno', value: 'TERRENO' },
  { label: 'Fazenda', value: 'FAZENDA' },
];

const loadProperties = async () => {
  loading.value = true;

  try {
    const response = await propertyService.getAll({
      ...filters.value,
      page: pagination.value.current_page,
    });

    properties.value = response.data;
    pagination.value = {
      current_page: response.current_page,
      last_page: response.last_page,
      per_page: response.per_page,
      total: response.total,
    };
  } catch (error) {
    console.error('Erro ao carregar imóveis:', error);
  } finally {
    loading.value = false;
  }
};

const viewProperty = (id: string) => {
  router.push(`/imovel/${id}`);
};

const formatPrice = (price: number) => {
  return new Intl.NumberFormat('pt-BR').format(price);
};

const getStatusColor = (status: string) => {
  const colors: Record<string, string> = {
    DISPONIVEL: 'positive',
    VENDIDO: 'negative',
    ALUGADO: 'warning',
  };
  return colors[status] || 'grey';
};

const getStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    DISPONIVEL: 'Disponível',
    VENDIDO: 'Vendido',
    ALUGADO: 'Alugado',
  };
  return labels[status] || status;
};

onMounted(async () => {
  await loadProperties();
});
</script>

<style scoped>
.property-card {
  transition: transform 0.2s;
}

.property-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
}

.ellipsis-2-lines {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>
