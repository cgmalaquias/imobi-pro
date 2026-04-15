<template>
  <q-page class="q-pa-md">
    <div class="text-h4 q-mb-md">Imóveis Disponíveis</div>

    <!-- Filtros -->
    <q-card class="q-mb-md">
      <q-card-section>
        <div class="row q-col-gutter-md">
          <div class="col-12 col-md-2">
            <q-select
              v-model="filters.type"
              :options="propertyTypesOptions"
              label="Tipo"
              outlined
              dense
              clearable
              emit-value
              map-options
              @update:model-value="updateFiltersAndLoad"
            />
          </div>

          <div class="col-12 col-md-2">
            <q-select
              v-model="filters.transactionType"
              :options="transactionTypesOptions"
              label="Venda / Aluguel"
              outlined
              dense
              clearable
              emit-value
              map-options
              @update:model-value="updateFiltersAndLoad"
            />
          </div>

          <div class="col-12 col-md-4">
            <q-input
              v-model="filters.city"
              label="Cidade"
              outlined
              dense
              clearable
              @keyup.enter="updateFiltersAndLoad"
            />
          </div>

          <div class="col-12 col-md-2">
            <q-input
              v-model.number="filters.minPrice"
              label="Preço Mínimo"
              type="number"
              outlined
              dense
              clearable
              prefix="R$"
              @keyup.enter="updateFiltersAndLoad"
            />
          </div>

          <div class="col-12 col-md-2">
            <q-input
              v-model.number="filters.maxPrice"
              label="Preço Máximo"
              type="number"
              outlined
              dense
              clearable
              prefix="R$"
              @keyup.enter="updateFiltersAndLoad"
            />
          </div>

          <div class="col-8">
            <q-input
              v-model="filters.search"
              label="Buscar por título, descrição ou endereço"
              outlined
              dense
              clearable
              debounce="500"
              @keyup.enter="updateFiltersAndLoad"
            >
              <template v-slot:prepend>
                <q-icon name="search" />
              </template>
            </q-input>
          </div>
          <div class="col-12 col-md-2 flex flex-center">
            <!-- ✅ Nova coluna para o botão Buscar -->
            <q-btn
              label="Buscar"
              color="primary"
              icon="search"
              class="full-width"
              @click="updateFiltersAndLoad"
            />
          </div>
          <div class="col-2 flex flex-center">
            <q-btn
              label="Limpar Filtros"
              color="grey"
              icon="clear"
              class="full-width"
              flat
              @click="clearFilters"
            />
          </div>
        </div>
      </q-card-section>
    </q-card>

    <!-- Grid de imóveis -->
    <div v-if="!loading && properties.length > 0" class="row q-col-gutter-md">
      <div v-for="property in properties" :key="property.id" class="col-12 col-sm-6 col-md-2">
        <q-card class="cursor-pointer property-card" @click="viewProperty(property)">
          <img :src="property.images?.[0]?.url || '/placeholder.jpg'" ratio="16/9" />
          <div class="absolute-top-right q-pa-sm">
            <q-badge
              :color="getStatusColor(property.status)"
              :label="getStatusLabel(property.status)"
            />
          </div>

          <q-card-section>
            <div class="text-h6 ellipsis-2-lines">{{ property.title }}</div>
            <div class="text-subtitle2 text-grey-7 q-mt-xs">
              <q-icon name="place" size="xs" />
              {{ property.city }} - {{ property.state }}
            </div>
            <div class="text-h6 text-weight-bold q-mt-sm">
              {{ formatPrice(property.price) }}
            </div>
          </q-card-section>
        </q-card>
      </div>
    </div>

    <div v-else-if="!loading && properties.length === 0" class="text-center q-py-xl">
      <div class="text-h6">Nenhum imóvel encontrado com os filtros aplicados.</div>
      <q-btn label="Limpar Filtros" color="primary" @click="clearFilters" class="q-mt-md" />
    </div>

    <div v-if="loading" class="text-center q-py-xl">
      <q-spinner-dots color="primary" size="3em" />
      <div class="text-h6 q-mt-md">Carregando imóveis...</div>
    </div>

    <!-- Paginação -->
    <div v-if="pagination.total > 0" class="q-pa-lg flex flex-center">
      <q-pagination
        v-model="pagination.current_page"
        :max="pagination.last_page"
        :max-pages="5"
        direction-links
        boundary-links
        icon-first="skip_previous"
        icon-last="skip_next"
        icon-prev="fast_rewind"
        icon-next="fast_forward"
        @update:model-value="updateFiltersAndLoad"
      />
    </div>
  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import type {
  Property,
  PropertyFilters,
  PropertyType,
  TransactionType,
} from 'src/services/property.service';
import { propertyService } from 'src/services/property.service'; // Importe PropertyType e TransactionType

const route = useRoute();
const router = useRouter();

const imageBaseUrl =
  import.meta.env.VITE_APP_IMAGE_URL || 'https://imobiproapi.agenciareinodigital.com.br/storage/';

const properties = ref<Property[]>([]);
const loading = ref(false);
const pagination = ref({
  current_page: 1,
  last_page: 1,
  per_page: 8,
  total: 0,
});

const filters = ref<PropertyFilters>({
  page: 1,
  limit: 12,
  type: undefined,
  city: undefined,
  status: 'DISPONIVEL', // Sempre buscar disponíveis
  transactionType: undefined,
  search: undefined,
  minPrice: undefined,
  maxPrice: undefined,
});

const propertyTypesOptions = [
  { label: 'Todos os Tipos', value: undefined }, // Opção para limpar o filtro
  { label: 'Casa', value: 'CASA' },
  { label: 'Apartamento', value: 'APARTAMENTO' },
  { label: 'Comercial', value: 'COMERCIAL' },
  { label: 'Terreno', value: 'TERRENO' },
  { label: 'Fazenda', value: 'FAZENDA' },
];

const transactionTypesOptions = [
  { label: 'Ambos', value: undefined }, // Opção para limpar o filtro (mostrar Venda e Aluguel)
  { label: 'Venda', value: 'VENDA' },
  { label: 'Aluguel', value: 'ALUGUEL' },
  { label: 'Troca', value: 'TROCA' },
  { label: 'A Combinar', value: 'A COMBINAR' },
];

// Função para aplicar filtros da URL ao estado local
const applyFiltersFromUrl = () => {
  // Resetar filtros para evitar que valores antigos persistam
  filters.value = {
    page: 1,
    limit: 8,
    status: 'DISPONIVEL',
    type: undefined,
    city: undefined,
    transactionType: undefined,
    search: undefined,
    minPrice: undefined,
    maxPrice: undefined,
  };

  // Aplicar filtros da URL
  if (route.query.page) filters.value.page = Number(route.query.page);
  if (route.query.limit) filters.value.limit = Number(route.query.limit);
  if (route.query.type) filters.value.type = route.query.type as PropertyType;
  if (route.query.city) filters.value.city = route.query.city as string;
  if (route.query.transactionType)
    filters.value.transactionType = route.query.transactionType as TransactionType;
  if (route.query.search) filters.value.search = route.query.search as string;
  if (route.query.minPrice) filters.value.minPrice = Number(route.query.minPrice);
  if (route.query.maxPrice) filters.value.maxPrice = Number(route.query.maxPrice);

  // Forçar a paginação a refletir a página da URL
  pagination.value.current_page = filters.value.page || 1;

  void loadProperties();
};

// Função para carregar imóveis com base nos filtros atuais
const loadProperties = async () => {
  loading.value = true;
  try {
    const apiFilters: PropertyFilters = {
      ...filters.value,
      page: pagination.value.current_page, // Usa a página da paginação
    };

    // Atualiza a URL para refletir os filtros atuais
    const newQuery: Record<string, string | number | undefined> = {};
    for (const key in apiFilters) {
      const value = apiFilters[key as keyof PropertyFilters];
      if (value !== undefined && value !== null && value !== '' && value !== 'undefined') {
        // Evita adicionar undefined/null/vazio na URL
        newQuery[key] = value;
      }
    }
    await router.replace({ query: newQuery });

    console.log('Sending filters to API:', apiFilters); // Para depuração

    const response = await propertyService.getAll(apiFilters);

    properties.value = response.data.map((property: Property) => ({
      ...property,
      images: (property.images || []).map((img: any) => ({
        ...img,
        url: `${imageBaseUrl}${img.path || img.url}`,
      })),
    }));

    pagination.value = {
      current_page: response.current_page,
      last_page: response.last_page,
      per_page: response.per_page,
      total: response.total,
    };
  } catch (error) {
    console.error('Erro ao carregar imóveis:', error);
    properties.value = []; // Limpa a lista em caso de erro
    pagination.value = { current_page: 1, last_page: 1, per_page: 8, total: 0 }; // Reseta paginação
  } finally {
    loading.value = false;
  }
};

// Função unificada para atualizar filtros e recarregar imóveis
const updateFiltersAndLoad = () => {
  filters.value.page = 1; // Sempre volta para a primeira página ao mudar um filtro
  pagination.value.current_page = 1; // Garante que a paginação também resete
  void loadProperties();
};

// Função para limpar todos os filtros
const clearFilters = () => {
  filters.value = {
    page: 1,
    limit: 8,
    status: 'DISPONIVEL',
    type: undefined,
    city: undefined,
    transactionType: undefined,
    search: undefined,
    minPrice: undefined,
    maxPrice: undefined,
  };
  pagination.value.current_page = 1;
  void loadProperties();
};

const viewProperty = (property: Property) => {
  void router.push({
    name: 'public-property-detail',
    params: { slug: property.slug || property.id },
  });
};

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

// Observa mudanças na rota (URL) e nos filtros
watch(
  () => route.query,
  () => {
    // Apenas aplica os filtros da URL se houver uma mudança real
    // Isso evita loops infinitos se loadProperties já atualizou a URL
    const currentQuery = JSON.stringify(route.query);
    const filtersAsQuery = JSON.stringify(
      Object.fromEntries(
        Object.entries(filters.value).filter(
          ([, value]) =>
            value !== undefined && value !== null && value !== '' && value !== 'undefined',
        ),
      ),
    );

    if (currentQuery !== filtersAsQuery) {
      applyFiltersFromUrl();
    }
  },
  { deep: true, immediate: true }, // 'immediate: true' para executar na montagem
);

// onMounted agora apenas inicia o watcher, que chamará applyFiltersFromUrl
onMounted(() => {
  // O watcher com immediate: true já cuidará da carga inicial
});
</script>

<style scoped>
.property-card {
  transition: transform 0.2s;
}
.q-card img {
  height: 200px !important;
  object-fit: cover;
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
  height: 3em !important;
}
</style>
