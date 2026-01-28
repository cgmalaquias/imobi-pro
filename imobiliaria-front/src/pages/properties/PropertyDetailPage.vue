<template>
  <q-page class="q-pa-md">
    <div v-if="!loading && property">
      <!-- Breadcrumb -->
      <div class="q-mb-md">
        <q-breadcrumbs>
          <q-breadcrumbs-el label="Admin" to="/admin" />
          <q-breadcrumbs-el label="Imóveis" to="/admin/properties" />
          <q-breadcrumbs-el :label="property.title" />
        </q-breadcrumbs>
      </div>

      <!-- Ações -->
      <div class="row items-center q-mb-md">
        <div class="col">
          <div class="text-h4">{{ property.title }}</div>
        </div>
        <div class="col-auto">
          <q-btn
            label="Editar"
            color="warning"
            icon="edit"
            :to="`/admin/properties/${property.id}/edit`"
            class="q-mr-sm"
          />
          <q-btn label="Voltar" color="grey-7" icon="arrow_back" to="/admin/properties" />
        </div>
      </div>

      <!-- Galeria de imagens -->
      <div class="row q-col-gutter-md q-mb-md">
        <div class="col-12 col-md-8">
          <q-carousel
            v-if="property.images && property.images.length > 0"
            v-model="currentImage"
            animated
            navigation
            infinite
            arrows
            height="400px"
            class="rounded-borders"
          >
            <q-carousel-slide
              v-for="(image, index) in property.images"
              :key="index"
              :name="index"
              :img-src="image.url"
            />
          </q-carousel>

          <div v-else class="flex flex-center bg-grey-3 rounded-borders" style="height: 400px">
            <div class="text-center">
              <q-icon name="image_not_supported" size="80px" color="grey-5" />
              <div class="text-grey-7 q-mt-md">Sem imagens</div>
            </div>
          </div>
        </div>

        <!-- Card de informações principais -->
        <div class="col-12 col-md-4">
          <q-card>
            <q-card-section>
              <div class="text-h4 text-primary">R$ {{ formatPrice(property.price) }}</div>
              <div class="text-subtitle1 text-grey-7 q-mt-sm">
                {{ getTypeLabel(property.type) }}
              </div>
              <q-badge
                :color="getStatusColor(property.status)"
                :label="getStatusLabel(property.status)"
                class="q-mt-sm"
              />
            </q-card-section>

            <q-separator />

            <q-card-section>
              <div class="row q-col-gutter-sm">
                <div class="col-6" v-if="property.bedrooms">
                  <div class="flex items-center">
                    <q-icon name="bed" size="sm" class="q-mr-sm" />
                    <span>{{ property.bedrooms }} quartos</span>
                  </div>
                </div>
                <div class="col-6" v-if="property.bathrooms">
                  <div class="flex items-center">
                    <q-icon name="bathroom" size="sm" class="q-mr-sm" />
                    <span>{{ property.bathrooms }} banheiros</span>
                  </div>
                </div>
                <div class="col-6" v-if="property.garages">
                  <div class="flex items-center">
                    <q-icon name="garage" size="sm" class="q-mr-sm" />
                    <span>{{ property.garages }} vagas</span>
                  </div>
                </div>
                <div class="col-6" v-if="property.area">
                  <div class="flex items-center">
                    <q-icon name="straighten" size="sm" class="q-mr-sm" />
                    <span>{{ property.area }} m²</span>
                  </div>
                </div>
              </div>
            </q-card-section>

            <q-separator />

            <q-card-section>
              <div class="text-caption text-grey-7">Criado em</div>
              <div class="text-body2">{{ formatDate(property.created_at) }}</div>

              <div class="text-caption text-grey-7 q-mt-sm">Atualizado em</div>
              <div class="text-body2">{{ formatDate(property.updated_at) }}</div>
            </q-card-section>
          </q-card>
        </div>
      </div>

      <!-- Descrição -->
      <q-card class="q-mb-md">
        <q-card-section>
          <div class="text-h6 q-mb-md">Descrição</div>
          <div class="text-body1" style="white-space: pre-line">
            {{ property.description }}
          </div>
        </q-card-section>
      </q-card>

      <!-- Características -->
      <q-card class="q-mb-md" v-if="property.features && property.features.length > 0">
        <q-card-section>
          <div class="text-h6 q-mb-md">Características</div>
          <div class="row q-col-gutter-sm">
            <div
              v-for="feature in property.features"
              :key="feature.id"
              class="col-12 col-sm-6 col-md-4"
            >
              <q-chip icon="check_circle" color="primary" text-color="white">
                {{ feature.name }}
              </q-chip>
            </div>
          </div>
        </q-card-section>
      </q-card>

      <!-- Localização -->
      <q-card class="q-mb-md">
        <q-card-section>
          <div class="text-h6 q-mb-md">Localização</div>
          <div class="text-body1">
            <q-icon name="place" class="q-mr-sm" />
            {{ property.address }}, {{ property.city }} - {{ property.state }}
            <span v-if="property.zip_code"> - CEP: {{ property.zip_code }}</span>
          </div>

          <div v-if="property.latitude && property.longitude" class="q-mt-md">
            <div class="text-caption text-grey-7">Coordenadas</div>
            <div class="text-body2">
              Latitude: {{ property.latitude }} | Longitude: {{ property.longitude }}
            </div>
          </div>
        </q-card-section>
      </q-card>

      <!-- Visitas agendadas -->
      <q-card v-if="property.visits && property.visits.length > 0">
        <q-card-section>
          <div class="text-h6 q-mb-md">Visitas Agendadas ({{ property.visits.length }})</div>

          <q-list separator>
            <q-item v-for="visit in property.visits" :key="visit.id">
              <q-item-section avatar>
                <q-avatar icon="event" color="primary" text-color="white" />
              </q-item-section>

              <q-item-section>
                <q-item-label>{{ visit.name }}</q-item-label>
                <q-item-label caption>{{ visit.email }} | {{ visit.phone }}</q-item-label>
              </q-item-section>

              <q-item-section side>
                <div class="text-grey-8 q-gutter-xs">
                  <div>{{ formatDate(visit.date) }} às {{ visit.time }}</div>
                  <q-badge
                    :color="getVisitStatusColor(visit.status)"
                    :label="getVisitStatusLabel(visit.status)"
                  />
                </div>
              </q-item-section>

              <q-item-section side>
                <q-btn
                  flat
                  dense
                  round
                  icon="visibility"
                  color="primary"
                  :to="`/admin/leads/${visit.id}`"
                >
                  <q-tooltip>Ver detalhes</q-tooltip>
                </q-btn>
              </q-item-section>
            </q-item>
          </q-list>
        </q-card-section>
      </q-card>
    </div>

    <!-- Loading -->
    <q-inner-loading :showing="loading">
      <q-spinner-gears size="50px" color="primary" />
    </q-inner-loading>
  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import type { Property } from 'src/services/property.service';
import { propertyService } from 'src/services/property.service';

const route = useRoute();
const router = useRouter();
const $q = useQuasar();

const property = ref<Property | null>(null);
const loading = ref(false);
const currentImage = ref(0);

const loadProperty = async () => {
  loading.value = true;

  try {
    const id = route.params.id as string;
    property.value = await propertyService.getById(id);
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: error.message || 'Erro ao carregar imóvel',
    });

    router.push('/admin/properties');
  } finally {
    loading.value = false;
  }
};

const formatPrice = (price: number) => {
  return new Intl.NumberFormat('pt-BR').format(price);
};

const formatDate = (date: string) => {
  return new Intl.DateTimeFormat('pt-BR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  }).format(new Date(date));
};

const getTypeLabel = (type: string) => {
  const labels: Record<string, string> = {
    CASA: 'Casa',
    APARTAMENTO: 'Apartamento',
    COMERCIAL: 'Comercial',
    TERRENO: 'Terreno',
    FAZENDA: 'Fazenda',
  };
  return labels[type] || type;
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

const getVisitStatusColor = (status: string) => {
  const colors: Record<string, string> = {
    PENDENTE: 'warning',
    CONFIRMADA: 'info',
    CONCLUIDA: 'positive',
    CANCELADA: 'negative',
  };
  return colors[status] || 'grey';
};

const getVisitStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    PENDENTE: 'Pendente',
    CONFIRMADA: 'Confirmada',
    CONCLUIDA: 'Concluída',
    CANCELADA: 'Cancelada',
  };
  return labels[status] || status;
};

onMounted(async () => {
  await loadProperty();
});
</script>
