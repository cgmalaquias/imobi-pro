<template>
  <q-page class="q-pa-md">
    <div class="row items-center q-mb-md">
      <div class="col">
        <div class="text-h4">Visitas Agendadas</div>
      </div>
    </div>

    <!-- Filtros -->
    <q-card class="q-mb-md">
      <q-card-section>
        <div class="row q-col-gutter-md">
          <div class="col-12 col-md-4">
            <q-select
              v-model="filters.status"
              :options="visitStatuses"
              label="Status"
              outlined
              dense
              clearable
              emit-value
              map-options
              @update:model-value="resetAndLoad"
            />
          </div>

          <div class="col-12 col-md-4">
            <q-input
              v-model="filters.search"
              label="Buscar por nome, e-mail ou telefone"
              outlined
              dense
              clearable
              debounce="300"
              @update:model-value="resetAndLoad"
            >
              <template v-slot:prepend>
                <q-icon name="search" />
              </template>
            </q-input>
          </div>

          <div class="col-12 col-md-4">
            <q-btn
              label="Limpar filtros"
              color="grey-7"
              icon="clear"
              @click="clearFilters"
              class="full-width"
            />
          </div>
        </div>
      </q-card-section>
    </q-card>

    <!-- Tabela de visitas -->
    <q-card>
      <q-table
        :rows="visits"
        :columns="columns"
        row-key="id"
        :loading="loading"
        v-model:pagination="pagination"
        @request="onRequest"
        flat
        bordered
        separator="cell"
        :rows-per-page-options="[5, 10, 20, 50]"
        no-data-label="Nenhuma visita encontrada"
      >
        <template v-slot:body-cell-client_name="props">
          <q-td :props="props">
            <div class="text-weight-bold">{{ props.row.client_name }}</div>
            <div class="text-caption text-grey-7">{{ props.row.client_email }}</div>
          </q-td>
        </template>

        <template v-slot:body-cell-property="props">
          <q-td :props="props">
            <router-link
              v-if="props.row.property"
              :to="`/admin/properties/${props.row.property.id}`"
              class="text-primary text-weight-bold"
            >
              {{ props.row.property.title || 'N/A' }}
            </router-link>
            <span v-else class="text-grey-6">N/A</span>
          </q-td>
        </template>

        <template v-slot:body-cell-preferred_date="props">
          <q-td :props="props">
            <div>{{ formatDate(props.row.preferred_date) }}</div>
            <div class="text-caption text-grey-7">{{ props.row.preferred_time }}</div>
          </q-td>
        </template>

        <template v-slot:body-cell-status="props">
          <q-td :props="props">
            <q-badge
              :label="getStatusLabel(props.row.status)"
              :color="getStatusColor(props.row.status)"
            />
          </q-td>
        </template>

        <template v-slot:body-cell-actions="props">
          <q-td :props="props" auto-width>
            <q-btn
              flat
              dense
              round
              icon="visibility"
              color="primary"
              size="sm"
              @click="viewVisit(props.row.id)"
            >
              <q-tooltip>Visualizar</q-tooltip>
            </q-btn>

            <q-btn
              flat
              dense
              round
              icon="edit"
              color="warning"
              size="sm"
              @click="editVisit(props.row)"
            >
              <q-tooltip>Editar status</q-tooltip>
            </q-btn>
          </q-td>
        </template>
      </q-table>
    </q-card>

    <!-- Dialog de edição de status -->
    <q-dialog v-model="showEditDialog">
      <q-card style="min-width: 400px">
        <q-card-section>
          <div class="text-h6">Atualizar Status</div>
          <div class="text-caption text-grey-7" v-if="editingVisit">
            {{ editingVisit.client_name }}
          </div>
        </q-card-section>

        <q-card-section>
          <q-select
            v-model="editingVisit.status"
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
          <q-btn label="Salvar" color="primary" @click="updateVisitStatus" :loading="submitting" />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import type { Visit, PaginatedResponse } from 'src/services/visit.service';
import { visitService } from 'src/services/visit.service';

const router = useRouter();
const $q = useQuasar();

const visits = ref<Visit[]>([]);
const loading = ref(false);
const submitting = ref(false);
const showEditDialog = ref(false);
const editingVisit = ref<Visit | null>(null);

const filters = ref({
  status: null as string | null,
  search: '',
});

const pagination = ref({
  sortBy: 'preferred_date',
  descending: true,
  page: 1,
  rowsPerPage: 10,
  rowsNumber: 0,
});

const columns = [
  {
    name: 'client_name',
    label: 'Cliente',
    field: 'client_name',
    align: 'left' as const,
    sortable: true,
  },
  {
    name: 'property',
    label: 'Imóvel',
    field: 'property',
    align: 'left' as const,
    sortable: false,
  },
  {
    name: 'client_phone',
    label: 'Telefone',
    field: 'client_phone',
    align: 'left' as const,
    sortable: false,
  },
  {
    name: 'preferred_date',
    label: 'Data / Hora',
    field: 'preferred_date',
    align: 'left' as const,
    sortable: true,
  },
  {
    name: 'status',
    label: 'Status',
    field: 'status',
    align: 'left' as const,
    sortable: true,
  },
  {
    name: 'actions',
    label: 'Ações',
    field: 'actions',
    align: 'center' as const,
    sortable: false,
  },
];

const visitStatuses = [
  { label: 'Pendente', value: 'PENDENTE' },
  { label: 'Confirmada', value: 'CONFIRMADA' },
  { label: 'Concluída', value: 'CONCLUIDA' },
  { label: 'Cancelada', value: 'CANCELADA' },
];

// Chamado pela q-table (clique em coluna, mudança de página, etc.)
const onRequest = async (props: { pagination: typeof pagination.value }) => {
  const { page, rowsPerPage, sortBy, descending } = props.pagination;

  pagination.value.page = page;
  pagination.value.rowsPerPage = rowsPerPage;
  pagination.value.sortBy = sortBy;
  pagination.value.descending = descending;

  await loadVisits();
};

// Carrega os dados usando o estado atual de pagination + filters
const loadVisits = async () => {
  loading.value = true;

  try {
    const response: PaginatedResponse<Visit> = await visitService.getAll(
      filters.value.status || undefined,
      filters.value.search || undefined,
      pagination.value.page,
      pagination.value.rowsPerPage,
      pagination.value.sortBy,
      pagination.value.descending ? 'desc' : 'asc',
    );
    // Garante array mesmo se a API retornar algo inesperado
    visits.value = Array.isArray(response.data) ? response.data : [];
    pagination.value.rowsNumber = response.total ?? 0;
  } catch (error: any) {
    console.error('Erro ao carregar visitas:', error); // ← temporário para debug
    visits.value = [];
    pagination.value.rowsNumber = 0;
    $q.notify({
      type: 'negative',
      message: error?.response?.data?.message || error?.message || 'Erro ao carregar visitas',
    });
  } finally {
    loading.value = false;
  }
};

// Reseta para página 1 e carrega (usado nos filtros)
const resetAndLoad = () => {
  pagination.value.page = 1;
  void loadVisits();
};

const clearFilters = () => {
  filters.value = { status: null, search: '' };
  resetAndLoad();
};

const viewVisit = (id: string) => {
  void router.push(`/admin/leads/${id}`);
};

const editVisit = (visitData: Visit) => {
  editingVisit.value = { ...visitData };
  showEditDialog.value = true;
};

const updateVisitStatus = async () => {
  if (!editingVisit.value) return;

  submitting.value = true;

  try {
    await visitService.update(editingVisit.value.id, {
      status: editingVisit.value.status,
    });

    $q.notify({ type: 'positive', message: 'Status atualizado com sucesso' });
    showEditDialog.value = false;
    await loadVisits();
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
  if (!date) return 'N/A';
  // Força interpretação como UTC para evitar problema de fuso
  return new Intl.DateTimeFormat('pt-BR', { timeZone: 'UTC' }).format(new Date(date));
};

const getStatusColor = (status: string) => {
  const map: Record<string, string> = {
    PENDENTE: 'warning',
    CONFIRMADA: 'info',
    CONCLUIDA: 'positive',
    CANCELADA: 'negative',
  };
  return map[status] ?? 'grey';
};

const getStatusLabel = (status: string) => {
  const map: Record<string, string> = {
    PENDENTE: 'Pendente',
    CONFIRMADA: 'Confirmada',
    CONCLUIDA: 'Concluída',
    CANCELADA: 'Cancelada',
  };
  return map[status] ?? status;
};

onMounted(() => {
  void loadVisits();
});
</script>
