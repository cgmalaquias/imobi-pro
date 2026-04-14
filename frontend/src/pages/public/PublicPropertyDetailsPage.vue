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
              :key="image.id || index"
              :name="index"
              :img-src="image.url"
            />
          </q-carousel>

          <!-- Fallback elegante se não houver imagens -->
          <div v-else class="bg-grey-3 rounded-borders flex flex-center" style="height: 400px">
            <div class="column items-center text-grey-7">
              <q-icon name="image_not_supported" size="48px" class="q-mb-sm" />
              <div>Este imóvel ainda não possui imagens cadastradas.</div>
            </div>
          </div>
        </div>

        <!-- Card de informações principais -->
        <div class="col-12 col-md-4">
          <q-card>
            <q-card-section>
              <div class="text-h4 text-primary">{{ formatPrice(property.price) }}</div>
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
          <div class="text-h6 q-mb-sm">Descrição</div>
          <div class="text-body1">
            {{ property.description }}
          </div>
        </q-card-section>
      </q-card>

      <!-- Localização -->
      <q-card class="q-mb-md">
        <q-card-section>
          <div class="text-h6 q-mb-sm">Localização</div>
          <div class="text-body2">
            {{ property.address }}
            <span v-if="property.neighborhood"> - {{ property.neighborhood }}</span
            ><br />
            {{ property.city }} - {{ property.state }}<br />
            <span v-if="property.zip_code">CEP: {{ property.zip_code }}</span>
          </div>
        </q-card-section>
      </q-card>

      <!-- Características / comodidades -->
      <q-card v-if="property.features && property.features.length" class="q-mb-md">
        <q-card-section>
          <div class="text-h6 q-mb-sm">Características</div>
          <div class="row q-col-gutter-sm">
            <div v-for="(feature, index) in property.features" :key="index" class="col-auto">
              <q-chip outline color="primary" text-color="primary">
                {{ typeof feature === 'string' ? feature : feature.name }}
              </q-chip>
            </div>
          </div>
        </q-card-section>
      </q-card>
    </div>

    <!-- Dialog de agendamento de visita -->
    <q-dialog v-model="showVisitDialog">
      <q-card style="min-width: 400px">
        <q-card-section>
          <div class="text-h6">Agendar Visita</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-input
            v-model="visitForm.client_name"
            label="Seu Nome*"
            outlined
            dense
            :rules="[(val) => !!val || 'Nome é obrigatório']"
            class="q-mb-sm"
          />
          <q-input
            v-model="visitForm.client_email"
            label="Seu E-mail*"
            outlined
            dense
            type="email"
            :rules="[(val) => !!val || 'E-mail é obrigatório']"
            class="q-mb-sm"
          />
          <q-input
            v-model="visitForm.client_phone"
            label="Seu Telefone*"
            outlined
            dense
            :rules="[(val) => !!val || 'E-mail é obrigatório']"
            class="q-mb-sm"
            mask="(##) # ####-####"
          />

          <div class="row q-col-gutter-sm q-mb-sm">
            <div class="col-6">
              <q-input
                v-model="visitForm.preferred_date"
                type="date"
                label="Data desejada"
                outlined
                dense
                :rules="[(val) => !!val || 'E-mail é obrigatório']"
                :min="minDate"
              />
            </div>
            <div class="col-6">
              <q-input
                v-model="visitForm.preferred_time"
                type="time"
                label="Horário desejado"
                outlined
                dense
                :rules="[(val) => !!val || 'E-mail é obrigatório']"
              />
            </div>
          </div>

          <q-input
            v-model="visitForm.message"
            label="Mensagem (opcional)"
            type="textarea"
            outlined
            rows="3"
          />
        </q-card-section>

        <q-card-actions align="right">
          <q-btn label="Cancelar" flat v-close-popup />
          <q-btn label="Agendar" color="primary" :loading="submitting" @click="scheduleVisit" />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useMeta } from 'quasar';
import { useRoute } from 'vue-router';
import { useQuasar } from 'quasar';
import { visitService, type CreateVisitData } from 'src/services/visit.service';
import { propertyService, type Property } from 'src/services/property.service';

const $q = useQuasar();
const route = useRoute();

const property = ref<Property | null>(null);
const loading = ref(true);
const submitting = ref(false);
const currentImage = ref(0);
const showVisitDialog = ref(false);

const visitForm = ref<Omit<CreateVisitData, 'property_id'>>({
  client_name: '',
  client_email: '',
  client_phone: '',
  preferred_date: '',
  preferred_time: '',
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
    // const id = route.params.id as string;
    // const fetchedProperty = await propertyService.getById(id);

    const slug = route.params.slug as string;
    const fetchedProperty = await propertyService.getBySlug(slug);

    // Garante que as imagens tenham URL completa
    fetchedProperty.images = (fetchedProperty.images || []).map((img: any) => ({
      ...img,
      url: `${import.meta.env.VITE_APP_IMAGE_URL}${img.path || img.url}`,
    }));

    property.value = fetchedProperty;
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: error?.message || 'Erro ao carregar imóvel',
    });
  } finally {
    loading.value = false;
  }
};

const scheduleVisit = async () => {
  if (!property.value) return;

  // validação simples no front
  if (
    !visitForm.value.client_name ||
    !visitForm.value.client_email ||
    !visitForm.value.client_phone ||
    !visitForm.value.preferred_date ||
    !visitForm.value.preferred_time
  ) {
    $q.notify({
      type: 'warning',
      message: 'Preencha todos os campos obrigatórios para agendar a visita.',
    });
    return;
  }

  submitting.value = true;

  try {
    await visitService.create({
      property_id: property.value.id,
      client_name: visitForm.value.client_name,
      client_email: visitForm.value.client_email,
      client_phone: visitForm.value.client_phone,
      preferred_date: visitForm.value.preferred_date,
      preferred_time: visitForm.value.preferred_time,
      message: visitForm.value.message,
    });

    $q.notify({
      type: 'positive',
      message: 'Visita agendada com sucesso! Entraremos em contato em breve.',
    });

    showVisitDialog.value = false;
    visitForm.value = {
      client_name: '',
      client_email: '',
      client_phone: '',
      preferred_date: '',
      preferred_time: '',
      message: '',
    };
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: error?.response?.data?.message || error?.message || 'Erro ao agendar visita',
    });
  } finally {
    submitting.value = false;
  }
};

const formatPrice = (price: number | null | undefined): string => {
  if (price === null || price === undefined) {
    return 'R$ 0,00'; // Ou qualquer valor padrão que você prefira para nulos/indefinidos
  }
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL',
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(price);
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

useMeta(() => {
  if (!property.value) {
    return { title: 'Carregando imóvel...' };
  }

  const tipoLabel: Record<string, string> = {
    CASA: 'Casa',
    APARTAMENTO: 'Apartamento',
    COMERCIAL: 'Comercial',
    TERRENO: 'Terreno',
    FAZENDA: 'Fazenda',
  };

  const transacaoLabel: Record<string, string> = {
    VENDA: 'à venda',
    ALUGUEL: 'para alugar',
    TROCA: 'para troca',
    'A COMBINAR': 'a combinar',
  };

  const tipo = tipoLabel[property.value.type] ?? property.value.type;
  const transacao = transacaoLabel[property.value.transaction_type] ?? '';
  const title = `${tipo} ${transacao} em ${property.value.neighborhood}, ${property.value.city} - ${property.value.state}`;
  const description = `${title}. ${property.value.description?.slice(0, 130) ?? ''}...`;
  const image = property.value.images?.[0]?.url ?? '';
  const url = `${window.location.origin}/imovel/${property.value.slug}`;

  return {
    title,
    meta: {
      description: {
        name: 'description',
        content: description,
      },
      ogTitle: {
        property: 'og:title',
        content: title,
      },
      ogDescription: {
        property: 'og:description',
        content: description,
      },
      ogImage: {
        property: 'og:image',
        content: image,
      },
      ogUrl: {
        property: 'og:url',
        content: url,
      },
      ogType: {
        property: 'og:type',
        content: 'article',
      },
    },
  };
});

onMounted(async () => {
  await loadProperty();
});
</script>
