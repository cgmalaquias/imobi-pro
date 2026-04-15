<template>
  <q-page class="q-pa-md">
    <div v-if="loading" class="text-center q-py-xl">
      <q-spinner-dots color="primary" size="3em" />
      <div class="text-h6 q-mt-md">Carregando detalhes do imóvel...</div>
    </div>

    <div v-else-if="!property" class="text-center q-py-xl">
      <div class="text-h6">Imóvel não encontrado.</div>
      <q-btn
        label="Voltar para a lista"
        color="primary"
        @click="$router.push({ name: 'public-properties' })"
        class="q-mt-md"
      />
    </div>

    <div v-else class="property-details-container">
      <!-- Breadcrumbs -->
      <q-breadcrumbs class="q-mb-md">
        <q-breadcrumbs-el label="Home" icon="home" to="/" />
        <q-breadcrumbs-el label="Imóveis" icon="business" to="/imoveis" />
        <q-breadcrumbs-el :label="property.title" />
      </q-breadcrumbs>

      <div class="row q-col-gutter-md">
        <!-- PRIMEIRA COLUNA: Carrossel de Imagens (Formato Retrato) -->
        <div class="col-12 col-md-8">
          <q-card flat bordered v-if="property.images && property.images.length > 0">
            <q-carousel
              v-model="currentImage"
              animated
              navigation
              infinite
              arrows
              control-color="white"
              class="rounded-borders main-carousel"
              @click="openImageDialog(currentImage)"
            >
              <q-carousel-slide
                v-for="(image, index) in property.images"
                :key="image.id || index"
                :name="index"
                class="q-pa-none"
              >
                <q-img
                  :src="image.url"
                  fit="contain"
                  class="full-width full-height cursor-pointer"
                  loading="lazy"
                  spinner-color="primary"
                >
                  <template v-slot:error>
                    <div class="absolute-full flex flex-center bg-negative text-white">
                      <q-icon name="broken_image" size="md" />
                      <div>Imagem não disponível</div>
                    </div>
                  </template>
                </q-img>
              </q-carousel-slide>
            </q-carousel>
            <!-- Miniaturas abaixo do carrossel principal (opcional, para navegação) -->
            <div class="q-mt-sm row q-gutter-sm justify-center">
              <q-img
                v-for="(image, index) in property.images"
                :key="image.id || index"
                :src="image.url"
                class="rounded-borders cursor-pointer thumbnail-bottom"
                :class="{ 'thumbnail-active': currentImage === index }"
                fit="cover"
                @click="currentImage = index"
                loading="lazy"
                spinner-color="primary"
              />
            </div>
          </q-card>
          <!-- Fallback elegante se não houver imagens -->
          <q-card
            flat
            bordered
            v-else
            class="bg-grey-3 rounded-borders flex flex-center"
            style="height: 400px"
          >
            <div class="column items-center text-grey-7">
              <q-icon name="image_not_supported" size="48px" class="q-mb-sm" />
              <div>Este imóvel ainda não possui imagens cadastradas.</div>
            </div>
          </q-card>
        </div>

        <!-- SEGUNDA COLUNA: Informações do Imóvel e Botão de Agendamento -->
        <div class="col-12 col-md-4">
          <q-card flat bordered class="full-height">
            <q-card-section>
              <div class="text-h5 text-weight-bold q-mb-sm">
                {{ formatPrice(property.price) }}
              </div>
              <div class="text-subtitle1 text-grey-8 q-mb-xs">
                {{ getTypeLabel(property.type) }}
              </div>
              <q-badge
                :color="getStatusColor(property.status)"
                class="q-pa-xs q-px-sm text-weight-bold"
              >
                {{ getStatusLabel(property.status) }}
              </q-badge>
              <div v-if="property.area" class="text-body2 text-grey-7 q-mt-sm">
                <q-icon name="square_foot" class="q-mr-xs" /> {{ property.area }} m²
              </div>
            </q-card-section>

            <q-separator />

            <q-card-section>
              <div class="text-h6 q-mb-sm">Descrição</div>
              <div class="text-body2 text-grey-9" style="white-space: pre-wrap">
                {{ property.description }}
              </div>
            </q-card-section>

            <q-separator />

            <q-card-section>
              <div class="text-h6 q-mb-sm">Localização</div>
              <div class="text-body2 text-grey-9">
                <span v-if="property.address">{{ property.address }}, </span>
                <span v-if="property.neighborhood">{{ property.neighborhood }} - </span>
                <span v-if="property.city">{{ property.city }} / </span>
                <span v-if="property.state">{{ property.state }}</span>
                <br />
                <span v-if="property.zip_code">CEP: {{ property.zip_code }}</span>
              </div>
            </q-card-section>

            <q-card-section>
              <q-btn
                label="Agendar Visita"
                color="primary"
                icon="event"
                class="full-width"
                size="lg"
                unelevated
                @click="showVisitDialog = true"
              />
            </q-card-section>
          </q-card>
        </div>
      </div>

      <!-- Diálogo de Agendamento de Visita -->
      <q-dialog v-model="showVisitDialog">
        <q-card style="min-width: 350px">
          <q-card-section>
            <div class="text-h6">Agendar Visita</div>
          </q-card-section>

          <q-card-section class="q-pt-none">
            <q-form @submit="scheduleVisit" class="q-gutter-md">
              <q-input
                v-model="visitForm.client_name"
                label="Seu Nome Completo"
                outlined
                dense
                :rules="[(val) => !!val || 'Nome é obrigatório']"
              />
              <q-input
                v-model="visitForm.client_email"
                label="Seu E-mail"
                outlined
                dense
                type="email"
                :rules="[
                  (val) => !!val || 'E-mail é obrigatório',
                  (val) => /.+@.+\..+/.test(val) || 'E-mail inválido',
                ]"
              />
              <q-input
                v-model="visitForm.client_phone"
                label="Seu Telefone (WhatsApp)"
                outlined
                dense
                mask="(##) #####-####"
                unmasked-value
                :rules="[(val) => !!val || 'Telefone é obrigatório']"
              />
              <q-input
                v-model="visitForm.preferred_date"
                label="Data Preferencial"
                outlined
                dense
                type="date"
                :rules="[(val) => !!val || 'Data é obrigatória']"
                :min="minDate"
              />
              <q-input
                v-model="visitForm.preferred_time"
                label="Hora Preferencial"
                outlined
                dense
                type="time"
                :rules="[(val) => !!val || 'Hora é obrigatória']"
              />
              <q-input
                v-model="visitForm.message"
                label="Mensagem (opcional)"
                outlined
                dense
                type="textarea"
                rows="3"
              />
              <q-card-actions align="right">
                <q-btn label="Cancelar" color="negative" flat @click="showVisitDialog = false" />
                <q-btn label="Agendar" color="primary" type="submit" :loading="submitting" />
              </q-card-actions>
            </q-form>
          </q-card-section>
        </q-card>
      </q-dialog>

      <!-- NOVO: Diálogo de Visualização de Imagem (Zoom) -->
      <q-dialog v-model="showImageDialog" full-screen>
        <q-card class="bg-black text-white no-scroll">
          <q-toolbar class="bg-dark">
            <q-toolbar-title>{{ property?.title }}</q-toolbar-title>
            <q-btn flat round dense icon="close" @click="showImageDialog = false" />
          </q-toolbar>

          <q-card-section class="full-height flex flex-center q-pa-none">
            <q-carousel
              v-model="dialogImageIndex"
              animated
              infinite
              arrows
              control-color="white"
              navigation
              height="calc(100vh - 50px)"
              class="full-width"
            >
              <q-carousel-slide
                v-for="(image, index) in property?.images"
                :key="image.id || index"
                :name="index"
                class="q-pa-none flex flex-center"
              >
                <q-img
                  :src="image.url"
                  fit="contain"
                  class="full-height"
                  style="max-width: 100%"
                  loading="lazy"
                  spinner-color="white"
                >
                  <template v-slot:error>
                    <div class="absolute-full flex flex-center bg-negative text-white">
                      <q-icon name="broken_image" size="lg" />
                      <div>Imagem não disponível</div>
                    </div>
                  </template>
                </q-img>
              </q-carousel-slide>
            </q-carousel>
          </q-card-section>
        </q-card>
      </q-dialog>
    </div>
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

// NOVO: Variáveis para o diálogo de imagem
const showImageDialog = ref(false);
const dialogImageIndex = ref(0);

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

// NOVO: Função para abrir o diálogo de imagem
const openImageDialog = (index: number) => {
  dialogImageIndex.value = index;
  showImageDialog.value = true;
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

<style scoped>
.property-details-container {
  max-width: 1200px;
  margin: 0 auto;
}

.main-carousel {
  height: 500px; /* Altura fixa para o carrossel principal */
}

.thumbnail-bottom {
  height: 80px;
  width: 80px;
  border: 2px solid transparent;
  transition: border-color 0.3s ease;
}

.thumbnail-active {
  border-color: var(--q-primary);
}
</style>
