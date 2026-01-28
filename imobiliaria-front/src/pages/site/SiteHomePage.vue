<template>
  <q-page class="bg-home">
    <!-- BANNER PRINCIPAL -->
    <section class="home-hero">
      <div class="home-hero__overlay">
        <div class="home-hero__content">
          <div class="text-subtitle2 text-uppercase text-weight-bold text-amber-3 q-mb-sm">
            Corretora de Imóveis
          </div>
          <div class="text-h3 text-weight-bold q-mb-sm">Encontre o imóvel perfeito para você</div>
          <div class="text-subtitle1 q-mb-lg">
            Compra, venda e locação de imóveis com atendimento personalizado.
          </div>

          <!-- CTA / TELEFONE -->
          <div class="row items-center q-gutter-sm">
            <q-btn
              color="amber-5"
              text-color="black"
              size="lg"
              unelevated
              rounded
              icon="whatsapp"
              label="Falar no WhatsApp"
              @click="openWhatsApp"
            />
            <div class="text-body2 q-ml-sm">
              ou ligue para <span class="text-bold">(41) 99585-0231</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- BLOCO DE FILTRO CENTRAL -->
    <section class="home-filter q-py-lg">
      <div class="home-container">
        <q-card flat bordered class="q-pa-md home-filter__card">
          <div class="row items-center q-col-gutter-md">
            <div class="col-12 col-md-4">
              <q-select
                v-model="filters.type"
                :options="propertyTypesOptions"
                label="Tipo de Imóvel"
                outlined
                dense
                clearable
                emit-value
                map-options
              />
            </div>
            <div class="col-12 col-md-4">
              <q-input v-model="filters.city" label="Cidade" outlined dense clearable />
            </div>
            <div class="col-12 col-md-4">
              <q-select
                v-model="filters.transactionType"
                :options="transactionTypesOptions"
                label="Venda / Aluguel"
                outlined
                dense
                clearable
                emit-value
                map-options
              />
            </div>
          </div>

          <div class="row items-center q-col-gutter-md q-mt-sm">
            <div class="col-12 col-md-9">
              <q-input
                v-model="filters.search"
                label="Buscar por título, bairro ou cidade"
                outlined
                dense
                clearable
                debounce="500"
              >
                <template #append>
                  <q-icon name="search" />
                </template>
              </q-input>
            </div>
            <div class="col-12 col-md-3">
              <q-btn
                color="primary"
                label="Buscar"
                icon="search"
                class="full-width"
                @click="goToPropertyList"
              />
            </div>
          </div>

          <div class="text-right q-mt-xs">
            <q-btn
              flat
              dense
              label="Aplicar filtros avançados"
              color="primary"
              @click="goToPropertyList"
            />
          </div>
        </q-card>
      </div>
    </section>

    <!-- SEÇÃO: IMÓVEIS PARA ALUGAR -->
    <section class="home-section">
      <div class="home-container">
        <div class="home-section__header">
          <div>
            <div class="home-section__title">Imóveis para Alugar</div>
            <div class="home-section__subtitle">
              As melhores opções de locação selecionadas para você.
            </div>
          </div>
          <q-btn
            flat
            color="primary"
            label="Ver todos para alugar"
            @click="goToPropertyList('ALUGUEL')"
          />
        </div>

        <q-inner-loading :showing="loadingRent">
          <q-spinner-gears size="40px" color="primary" />
        </q-inner-loading>

        <div v-if="!loadingRent && rentProperties.length === 0" class="text-grey-6 q-mt-md">
          Nenhum imóvel para alugar no momento.
        </div>

        <div v-else class="row q-col-gutter-md q-mt-sm">
          <div
            v-for="property in rentProperties"
            :key="property.id"
            class="col-12 col-sm-6 col-md-4 col-lg-3"
          >
            <PropertyCard :property="property" @click="openPublicDetails(property.id)" />
          </div>
        </div>
      </div>
    </section>

    <!-- SEÇÃO: IMÓVEIS PARA VENDER -->
    <section class="home-section home-section--alt">
      <div class="home-container">
        <div class="home-section__header">
          <div>
            <div class="home-section__title">Imóveis para Vender</div>
            <div class="home-section__subtitle">
              As melhores oportunidades de compra em destaque.
            </div>
          </div>
          <q-btn
            flat
            color="primary"
            label="Ver todos para vender"
            @click="goToPropertyList('VENDA')"
          />
        </div>

        <q-inner-loading :showing="loadingSale">
          <q-spinner-gears size="40px" color="primary" />
        </q-inner-loading>

        <div v-if="!loadingSale && saleProperties.length === 0" class="text-grey-6 q-mt-md">
          Nenhum imóvel para venda no momento.
        </div>

        <div v-else class="row q-col-gutter-md q-mt-sm">
          <div
            v-for="property in saleProperties"
            :key="property.id"
            class="col-12 col-sm-6 col-md-4 col-lg-3"
          >
            <PropertyCard :property="property" @click="openPublicDetails(property.id)" />
          </div>
        </div>
      </div>
    </section>

    <!-- SEÇÃO: IMÓVEIS EM DESTAQUE -->
    <section class="home-section">
      <div class="home-container">
        <div class="home-section__header">
          <div>
            <div class="home-section__title">Imóveis em Destaque</div>
            <div class="home-section__subtitle">Seleção especial de imóveis exclusivos.</div>
          </div>
          <q-btn
            flat
            color="primary"
            label="Ver todos"
            @click="goToPropertyList(undefined, true)"
          />
        </div>

        <q-inner-loading :showing="loadingFeatured">
          <q-spinner-gears size="40px" color="primary" />
        </q-inner-loading>

        <div v-if="!loadingFeatured && featuredProperties.length === 0" class="text-grey-6 q-mt-md">
          Nenhum imóvel em destaque no momento.
        </div>

        <div v-else class="row q-col-gutter-md q-mt-sm">
          <div
            v-for="property in featuredProperties"
            :key="property.id"
            class="col-12 col-sm-6 col-md-4 col-lg-3"
          >
            <PropertyCard :property="property" @click="openPublicDetails(property.id)" />
          </div>
        </div>
      </div>
    </section>
  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import {
  usePropertyStore,
  Property,
  PropertyType,
  TransactionType,
  PropertyFilters,
} from 'src/stores/property';
import PropertyCard from 'src/components/PropertyCard.vue'; // vamos criar já já

const router = useRouter();
const propertyStore = usePropertyStore();

// cores e identidade já estão no tema/global, aqui só usamos classes

const filters = ref<PropertyFilters & { transactionType?: TransactionType; search?: string }>({
  page: 1,
  limit: 12,
  type: undefined,
  city: undefined,
  status: 'DISPONIVEL',
  featured: undefined,
});

// selects
const propertyTypesOptions: Array<{ label: string; value: PropertyType }> = [
  { label: 'Casa', value: 'CASA' },
  { label: 'Apartamento', value: 'APARTAMENTO' },
  { label: 'Terreno', value: 'TERRENO' },
  { label: 'Comercial', value: 'COMERCIAL' },
  { label: 'Rural', value: 'RURAL' },
];

const transactionTypesOptions: Array<{ label: string; value: TransactionType }> = [
  { label: 'Venda', value: 'VENDA' },
  { label: 'Aluguel', value: 'ALUGUEL' },
  { label: 'Ambos', value: 'AMBOS' },
];

// estados de loading por seção
const loadingRent = ref(false);
const loadingSale = ref(false);
const loadingFeatured = ref(false);

const rentProperties = ref<Property[]>([]);
const saleProperties = ref<Property[]>([]);
const featuredProperties = ref<Property[]>([]);

const loadRent = async (): Promise<void> => {
  loadingRent.value = true;
  try {
    const data = await propertyStore.fetchProperties({
      page: 1,
      limit: 8,
      status: 'DISPONIVEL',
      // assumindo que transactionType está no model (VENDA/ALUGUEL/AMBOS)
    } as PropertyFilters & { transactionType?: TransactionType });
    rentProperties.value = data.properties.filter(
      (p) => p.transactionType === 'ALUGUEL' || p.transactionType === 'AMBOS',
    );
  } finally {
    loadingRent.value = false;
  }
};

const loadSale = async (): Promise<void> => {
  loadingSale.value = true;
  try {
    const data = await propertyStore.fetchProperties({
      page: 1,
      limit: 8,
      status: 'DISPONIVEL',
    });
    saleProperties.value = data.properties.filter(
      (p) => p.transactionType === 'VENDA' || p.transactionType === 'AMBOS',
    );
  } finally {
    loadingSale.value = false;
  }
};

const loadFeatured = async (): Promise<void> => {
  loadingFeatured.value = true;
  try {
    const data = await propertyStore.fetchProperties({
      page: 1,
      limit: 8,
      status: 'DISPONIVEL',
      featured: true,
    });
    featuredProperties.value = data.properties;
  } finally {
    loadingFeatured.value = false;
  }
};

const goToPropertyList = (transactionType?: TransactionType, onlyFeatured = false): void => {
  const query: Record<string, string> = {};

  if (filters.value.type) query.type = filters.value.type;
  if (filters.value.city) query.city = filters.value.city;
  if (filters.value.search) query.search = filters.value.search;
  if (transactionType) query.transactionType = transactionType;
  if (onlyFeatured) query.featured = 'true';

  router.push({ name: 'public-properties', query });
};

const openPublicDetails = (id: string): void => {
  router.push({ name: 'public-property-details', params: { id } });
};

const openWhatsApp = (): void => {
  window.open('https://wa.me/5541995850231', '_blank');
};

onMounted(async () => {
  await Promise.all([loadRent(), loadSale(), loadFeatured()]);
});
</script>

<style scoped>
.bg-home {
  background: #f5f5f5;
}

/* banner */
.home-hero {
  position: relative;
  height: 360px;
  background-image: url('/images/banner-corretora.jpg'); /* ajuste para sua imagem */
  background-size: cover;
  background-position: center;
}

.home-hero__overlay {
  height: 100%;
  width: 100%;
  background: linear-gradient(90deg, rgba(0, 0, 0, 0.65), rgba(0, 0, 0, 0.2));
  display: flex;
  align-items: center;
}

.home-hero__content {
  max-width: 600px;
  margin-left: 8%;
  color: white;
}

/* container central */
.home-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 16px;
}

/* filtro */
.home-filter {
  margin-top: -60px;
}

.home-filter__card {
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.16);
}

/* seções */
.home-section {
  padding: 32px 0;
  background: #f5f5f5;
}

.home-section--alt {
  background: #e9e9e9;
}

.home-section__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
}

.home-section__title {
  font-size: 20px;
  font-weight: 700;
}

.home-section__subtitle {
  font-size: 14px;
  color: #666;
}
</style>
