<template>
  <q-page class="q-pa-md">
    <div v-if="!loading && visit">
      <!-- Breadcrumb -->
      <div class="q-mb-md">
        <q-breadcrumbs>
          <q-breadcrumbs-el label="Admin" to="/admin" />
          <!-- <q-breadcrumbs-el label="Visitas" to="/admin/leads" /> -->
          <q-breadcrumbs-el label="Visitas" to="#" class="disabled" />
          <q-breadcrumbs-el :label="visit.client_name" />
        </q-breadcrumbs>
      </div>

      <!-- Ações -->
      <div class="row items-center q-mb-md">
        <div class="col">
          <div class="text-h4">{{ visit.client_name }}</div>
        </div>
        <div class="col-auto">
          <q-btn label="Voltar" color="grey-7" icon="arrow_back" to="/admin/leads" />
          <!-- <q-btn label="Voltar" color="grey-7" icon="arrow_back" to="#" class="disabled" /> -->
        </div>
      </div>

      <!-- Informações do cliente -->
      <div class="row q-col-gutter-md">
        <div class="col-12 col-md-6">
          <q-card>
            <q-card-section>
              <div class="text-h6 q-mb-md">Informações do Cliente</div>

              <div class="q-mb-md">
                <div class="text-caption text-grey-7">Nome</div>
                <div class="text-body1">{{ visit.client_name }}</div>
              </div>

              <div class="q-mb-md">
                <div class="text-caption text-grey-7">E-mail</div>
                <div class="text-body1">
                  <a :href="`mailto:${visit.client_email}`">{{ visit.client_email }}</a>
                </div>
              </div>

              <div class="q-mb-md">
                <div class="text-caption text-grey-7">Telefone</div>
                <div class="text-body1">
                  <a :href="`tel:${visit.client_phone}`">{{ visit.client_phone }}</a>
                </div>
              </div>

              <div v-if="visit.message">
                <div class="text-caption text-grey-7">Mensagem</div>
                <div class="text-body1" style="white-space: pre-line">
                  {{ visit.message }}
                </div>
              </div>
            </q-card-section>
          </q-card>
        </div>

        <div class="col-12 col-md-6">
          <q-card>
            <q-card-section>
              <div class="text-h6 q-mb-md">Agendamento</div>
              <div class="q-mb-md">
                <div class="text-caption text-grey-7">Data</div>
                <div class="text-body1">{{ formatDate(visit.preferred_date) }}</div>
              </div>

              <div class="q-mb-md">
                <div class="text-caption text-grey-7">Horário</div>
                <div class="text-body1">{{ visit.preferred_time }}</div>
              </div>

              <div class="q-mb-md">
                <div class="text-caption text-grey-7">Status</div>
                <q-badge
                  :label="getStatusLabel(visit.status)"
                  :color="getStatusColor(visit.status)"
                  class="q-mt-sm"
                />
              </div>

              <q-btn
                label="Atualizar Status"
                color="primary"
                @click="showEditDialog = true"
                class="full-width q-mt-md"
              />
            </q-card-section>
          </q-card>
        </div>

        <div class="col-12" v-if="visit.property">
          <q-card>
            <q-card-section>
              <div class="text-h6 q-mb-md">Imóvel de Interesse</div>

              <div class="row q-col-gutter-md">
                <div class="col-12 col-md-3">
                  <img
                    v-if="visit.property.images?.[0]"
                    :src="visit.property.images[0].url"
                    ratio="1"
                    class="rounded-borders"
                  />
                  <!-- Para usar q-img, você precisaria importar o componente e garantir que a URL da imagem esteja completa -->
                  <!-- <q-img
                    v-if="visit.property.images?.[0]"
                    :src="visit.property.images[0].url"
                    ratio="1"
                    class="rounded-borders"
                  /> -->
                </div>

                <div class="col-12 col-md-9">
                  <div class="q-mb-md">
                    <div class="text-h6">{{ visit.property.title }}</div>
                    <div class="text-subtitle2 text-grey-7">
                      {{ visit.property.city }} - {{ visit.property.state }}
                    </div>
                  </div>

                  <div class="row q-col-gutter-md">
                    <div class="col-12 col-md-6">
                      <div class="text-caption text-grey-7">Preço</div>
                      <div class="text-h6 text-primary">
                        {{ formatPrice(visit.property.price) }}
                      </div>
                    </div>

                    <div class="col-12 col-md-6">
                      <div class="text-caption text-grey-7">Tipo</div>
                      <div class="text-body1">
                        {{ getTypeLabel(visit.property.type) }}
                      </div>
                    </div>
                  </div>

                  <q-btn
                    label="Ver Imóvel"
                    color="primary"
                    :to="`/admin/properties/${visit.property.id}`"
                    class="q-mt-md"
                  />
                </div>
              </div>
            </q-card-section>
          </q-card>
        </div>
      </div>
    </div>

    <!-- Loading -->
    <q-inner-loading :showing="loading">
      <q-spinner-gears size="50px" color="primary" />
    </q-inner-loading>

    <!-- Dialog de edição de status -->
    <q-dialog v-model="showEditDialog">
      <q-card style="min-width: 400px">
        <q-card-section>
          <div class="text-h6">Atualizar Status</div>
        </q-card-section>

        <q-card-section>
          <q-select
            v-model="editingStatus"
            :options="visitStatuses"
            label="Status"
            outlined
            dense
            emit-value
            map-options
          />
        </q-card-section>

        <q-card-actions align="right">
          <q-btn label="Cancelar" flat v-close-popup />
          <q-btn label="Salvar" color="primary" @click="updateStatus" :loading="submitting" />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import { api } from 'src/boot/api';
import type { Visit } from 'src/services/visit.service';
import { visitService } from 'src/services/visit.service';

const route = useRoute();
const router = useRouter();
const $q = useQuasar();

const visit = ref<Visit | null>(null);
const loading = ref(false);
const submitting = ref(false);
const showEditDialog = ref(false);
const editingStatus = ref('');

const visitStatuses = [
  { label: 'Pendente', value: 'PENDENTE' },
  { label: 'Confirmada', value: 'CONFIRMADA' },
  { label: 'Concluída', value: 'CONCLUIDA' },
  { label: 'Cancelada', value: 'CANCELADA' },
];

const loadVisit = async () => {
  loading.value = true;

  try {
    const id = route.params.id as string;
    const response = await api.get(`/visits/${id}`);
    visit.value = response;
    editingStatus.value = response.status;
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: error.message || 'Erro ao carregar visita',
    });

    void router.push('/admin/leads');
  } finally {
    loading.value = false;
  }
};

const updateStatus = async () => {
  if (!visit.value) return;

  submitting.value = true;

  try {
    await visitService.update(visit.value.id, {
      status: editingStatus.value, // Agora editingStatus já é a string correta
    });

    $q.notify({
      type: 'positive',
      message: 'Status atualizado com sucesso',
    });

    showEditDialog.value = false;
    await loadVisit(); // Recarrega a visita para refletir o novo status
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: error?.response?.data?.message || error?.message || 'Erro ao atualizar status',
    });
  } finally {
    submitting.value = false;
  }
};

const formatDate = (date: string) => {
  return new Intl.DateTimeFormat('pt-BR').format(new Date(date));
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
    PENDENTE: 'warning',
    CONFIRMADA: 'info',
    CONCLUIDA: 'positive',
    CANCELADA: 'negative',
  };
  return colors[status] || 'grey';
};

const getStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    PENDENTE: 'Pendente',
    CONFIRMADA: 'Confirmada',
    CONCLUIDA: 'Concluída',
    CANCELADA: 'Cancelada',
  };
  return labels[status] || status;
};

onMounted(async () => {
  await loadVisit();
});
</script>
