<template>
  <q-page class="q-pa-md">
    <div v-if="!loading && property">
      <!-- Breadcrumb -->
      <div class="q-mb-md">
        <q-breadcrumbs>
          <q-breadcrumbs-el label="Home" to="/" />
          <q-breadcrumbs-el label="Imóveis" to="/imoveis" />
          <q-breadcrumbs-el :label="property.title" />
        </q-breadcrumbs>
      </div>

      <!-- Galeria de imagens -->
      <div class="row q-col-gutter-md q-mb-md">
        <div class="col-12 col-md-8">
          <q-carousel
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
              <q-btn
                label="Agendar Visita"
                color="primary"
                icon="event"
                class="full-width"
                @click="showVisitDialog = true"
              />
            </q-card-section>
          </q-card>
        </div>
      </div>

      <!-- Descrição -->
      <q-card class="q-mb-md">
        <q-card-section>
          <div class="text-h6">Descrição</div>
          <div class="text-body1 q-mt-sm" style="white-space: pre-line">
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
      <q-card>
        <q-card-section>
          <div class="text-h6 q-mb-md">Localização</div>
          <div class="text-body1">
            <q-icon name="place" class="q-mr-sm" />
            {{ property.address }}, {{ property.city }} - {{ property.state }}
            <span v-if="property.zip_code"> - CEP: {{ property.zip_code }}</span>
          </div>
        </q-card-section>
      </q-card>
    </div>

    <!-- Loading -->
    <q-inner-loading :showing="loading">
      <q-spinner-gears size="50px" color="primary" />
    </q-inner-loading>

    <!-- Dialog de agendamento -->
    <q-dialog v-model="showVisitDialog">
      <q-card style="min-width: 400px">
        <q-card-section>
          <div class="text-h6">Agendar Visita</div>
        </q-card-section>

        <q-card-section>
          <q-form @submit="scheduleVisit">
            <q-input
              v-model="visitForm.name"
              label="Nome completo"
              outlined
              dense
              :rules="[(val) => !!val || 'Nome obrigatório']"
              class="q-mb-md"
            />

            <q-input
              v-model="visitForm.email"
              label="E-mail"
              type="email"
              outlined
              dense
              :rules="[(val) => !!val || 'E-mail obrigatório']"
              class="q-mb-md"
            />

            <q-input
              v-model="visitForm.phone"
              label="Telefone"
              mask="(##) #####-####"
              outlined
              dense
              :rules="[(val) => !!val || 'Telefone obrigatório']"
              class="q-mb-md"
            />

            <q-input
              v-model="visitForm.date"
              label="Data"
              type="date"
              outlined
              dense
              :rules="[(val) => !!val || 'Data obrigatória']"
              :min="minDate"
              class="q-mb-md"
            />

            <q-input
              v-model="visitForm.time"
              label="Horário"
              type="time"
              outlined
              dense
              :rules="[(val) => !!val || 'Horário obrigatório']"
              class="q-mb-md"
            />

            <q-input
              v-model="visitForm.message"
              label="Mensagem (opcional)"
              type="textarea"
              outlined
              rows="3"
            />

            <div class="row q-gutter-sm q-mt-md">
              <q-btn label="Cancelar" flat v-close-popup />
              <q-btn type="submit" label="Agendar" color="primary" :loading="submitting" />
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRoute } from 'vue-router';
import { useQuasar } from 'quasar';
import type { Property } from 'src/services/property.service';
import { propertyService } from 'src/services/property.service';
import { visitService } from 'src/services/visit.service';

const route = useRoute();
const $q = useQuasar();

const property = ref<Property | null>(null);
const loading = ref(false);
const currentImage = ref(0);
const showVisitDialog = ref(false);
const submitting = ref(false);

const visitForm = ref({
  name: '',
  email: '',
  phone: '',
  date: '',
  time: '',
  message: '',
});

const minDate = computed(() => {
  const tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);
  return tomorrow.toISOString().split('T')[0];
});

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
  } finally {
    loading.value = false;
  }
};

const scheduleVisit = async () => {
  if (!property.value) return;

  submitting.value = true;

  try {
    await visitService.create({
      property_id: property.value.id,
      ...visitForm.value,
    });

    $q.notify({
      type: 'positive',
      message: 'Visita agendada com sucesso! Entraremos em contato em breve.',
    });

    showVisitDialog.value = false;
    visitForm.value = {
      name: '',
      email: '',
      phone: '',
      date: '',
      time: '',
      message: '',
    };
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: error.message || 'Erro ao agendar visita',
    });
  } finally {
    submitting.value = false;
  }
};

const formatPrice = (price: number) => {
  return new Intl.NumberFormat('pt-BR').format(price);
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

onMounted(async () => {
  await loadProperty();
});
</script>
