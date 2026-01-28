<template>
  <q-page class="q-pa-md">
    <div class="row items-center q-mb-md">
      <div class="col">
        <div class="text-h4">Visitas Agendadas</div>
      </div>
      <div class="col-auto">
        <q-btn label="Novo Lead" color="primary" icon="add" to="/admin/leads/create" />
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
              @update:model-value="loadVisits"
            />
          </div>

          <div class="col-12 col-md-4">
            <q-input
              v-model="filters.search"
              label="Buscar por nome ou e-mail"
              outlined
              dense
              clearable
              @update:model-value="loadVisits"
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
        @request="loadVisits"
        flat
        bordered
      >
        <template v-slot:body-cell-name="props">
          <q-td :props="props">
            <div class="font-bold">{{ props.row.name }}</div>
            <div class="text-caption text-grey-7">{{ props.row.email }}</div>
          </q-td>
        </template>

        <template v-slot:body-cell-property="props">
          <q-td :props="props">
            {{ props.row.property?.title || 'N/A' }}
          </q-td>
        </template>

        <template v-slot:body-cell-date="props">
          <q-td :props="props">
            {{ formatDate(props.row.date) }}
            <div class="text-caption text-grey-7">{{ props.row.time }}</div>
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
          <q-td :props="props">
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
              @click="editVisit(props.row.id)"
            >
              <q-tooltip>Editar status</q-tooltip>
            </q-btn>
          </q-td>
        </template>
      </q-table>
    </q-card>

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
            v-model="editingVisit.status"
            :options="visitStatuses"
            label="Status"
            outlined
            dense
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
import type { Visit } from 'src/services/visit.service';
import { visitService } from 'src/services/visit.service';

const router = useRouter();
const $q = useQuasar();

const visits = ref<Visit[]>([]);
const loading = ref(false);
const submitting = ref(false);
const showEditDialog = ref(false);
const filters = ref({
  status: null as string | null,
  search: '',
});
const pagination = ref({
  sortBy: 'date',
  descending: true,
  page: 1,
  rowsPerPage: 10,
  rowsNumber: 0,
});

const editingVisit = ref<Visit | null>(null);

const columns = [
  {
    name: 'name',
    label: 'Cliente',
    field: 'name',
    align: 'left',
  },
  {
    name: 'property',
    label: 'Imóvel',
    field: 'property',
    align: 'left',
  },
  {
    name: 'phone',
    label: 'Telefone',
    field: 'phone',
    align: 'left',
  },
  {
    name: 'date',
    label: 'Data/Hora',
    field: 'date',
    align: 'left',
  },
  {
    name: 'status',
    label: 'Status',
    field: 'status',
    align: 'left',
  },
  {
    name: 'actions',
    label: 'Ações',
    field: 'actions',
    align: 'center',
  },
];

const visitStatuses = [
  { label: 'Pendente', value: 'PENDENTE' },
  { label: 'Confirmada', value: 'CONFIRMADA' },
  { label: 'Concluída', value: 'CONCLUIDA' },
  { label: 'Cancelada', value: 'CANCELADA' },
];

const loadVisits = async () => {
  loading.value = true;

  try {
    const response = await visitService.getAll(filters.value.status || undefined);

    visits.value = response.data;
    pagination.value.rowsNumber = response.total;
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: error.message || 'Erro ao carregar visitas',
    });
  } finally {
    loading.value = false;
  }
};

const clearFilters = () => {
  filters.value = {
    status: null,
    search: '',
  };
  loadVisits();
};

const viewVisit = (id: string) => {
  router.push(`/admin/leads/${id}`);
};

const editVisit = (visit: Visit) => {
  editingVisit.value = { ...visit };
  showEditDialog.value = true;
};

const updateVisitStatus = async () => {
  if (!editingVisit.value) return;

  submitting.value = true;

  try {
    await visitService.update(editingVisit.value.id, {
      status: editingVisit.value.status as any,
    });

    $q.notify({
      type: 'positive',
      message: 'Status atualizado com sucesso',
    });

    showEditDialog.value = false;
    loadVisits();
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: error.message || 'Erro ao atualizar status',
    });
  } finally {
    submitting.value = false;
  }
};

const formatDate = (date: string) => {
  return new Intl.DateTimeFormat('pt-BR').format(new Date(date));
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
  await loadVisits();
});
</script>
