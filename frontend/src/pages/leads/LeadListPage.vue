<template>
  <q-page class="q-pa-md">
    <div class="row items-center q-mb-lg">
      <div class="col">
        <h1 class="text-h4 text-weight-bold q-ma-none">Leads (CRM)</h1>
        <p class="text-subtitle2 text-grey-7">Gerencie o pipeline de vendas</p>
      </div>
      <div class="col-auto">
        <q-btn color="primary" label="Novo Lead" icon="add" @click="showLeadDialog = true" />
      </div>
    </div>

    <!-- Métricas -->
    <div class="row q-col-gutter-md q-mb-lg">
      <div class="col-xs-12 col-sm-6 col-md-3">
        <StatCard
          title="Total de Leads"
          :value="leadStore.metrics?.totalLeads || 0"
          icon="trending_up"
          color="blue"
          :loading="metricsLoading"
        />
      </div>
      <div class="col-xs-12 col-sm-6 col-md-3">
        <StatCard
          title="Leads Novos"
          :value="leadStore.metrics?.newLeads || 0"
          icon="new_releases"
          color="orange"
          :loading="metricsLoading"
        />
      </div>
      <div class="col-xs-12 col-sm-6 col-md-3">
        <StatCard
          title="Fechados"
          :value="leadStore.metrics?.closedLeads || 0"
          icon="check_circle"
          color="positive"
          :loading="metricsLoading"
        />
      </div>
      <div class="col-xs-12 col-sm-6 col-md-3">
        <StatCard
          title="Taxa de Conversão"
          :value="leadStore.metrics?.conversionRate || '0%'"
          icon="percent"
          color="purple"
          :loading="metricsLoading"
        />
      </div>
    </div>

    <!-- Filtros -->
    <q-card class="q-mb-md">
      <q-card-section>
        <div class="row q-col-gutter-md">
          <div class="col-xs-12 col-md-3">
            <q-select
              v-model="filters.status"
              outlined
              dense
              label="Status"
              :options="statusOptions"
              emit-value
              map-options
              clearable
              @update:model-value="handleFilter"
            />
          </div>

          <div class="col-xs-12 col-md-3">
            <q-select
              v-model="filters.stage"
              outlined
              dense
              label="Estágio"
              :options="stageOptions"
              emit-value
              map-options
              clearable
              @update:model-value="handleFilter"
            />
          </div>

          <div class="col-xs-12 col-md-3">
            <q-input
              v-model="filters.search"
              outlined
              dense
              placeholder="Buscar cliente ou imóvel..."
              @keyup.enter="handleFilter"
            >
              <template v-slot:prepend>
                <q-icon name="search" />
              </template>
            </q-input>
          </div>

          <div class="col-xs-12 col-md-3">
            <q-btn
              flat
              color="primary"
              label="Limpar"
              icon="clear"
              class="full-width"
              @click="clearFilters"
            />
          </div>
        </div>
      </q-card-section>
    </q-card>

    <!-- Visualização Kanban -->
    <div v-if="viewMode === 'kanban'" class="row q-col-gutter-md kanban-container">
      <div
        v-for="stage in stages"
        :key="stage.value"
        class="col-xs-12 col-sm-6 col-md-4 col-lg-2-4"
      >
        <div class="kanban-column">
          <div class="kanban-header" :style="{ backgroundColor: stage.color }">
            <h6 class="text-weight-bold q-ma-none text-white">{{ stage.label }}</h6>
            <q-badge color="white" text-color="black">
              {{ getLeadsByStage(stage.value).length }}
            </q-badge>
          </div>

          <q-scroll-area class="kanban-cards">
            <div class="q-pa-sm q-gutter-sm">
              <q-card
                v-for="lead in getLeadsByStage(stage.value)"
                :key="lead.id"
                class="lead-card cursor-pointer"
                @click="$router.push(`/leads/${lead.id}`)"
              >
                <q-card-section class="q-pa-md">
                  <div class="flex items-center justify-between q-mb-sm">
                    <q-avatar color="primary" text-color="white" size="32px">
                      {{ lead.client?.name.charAt(0).toUpperCase() }}
                    </q-avatar>
                    <q-badge :color="getStatusColor(lead.status)">
                      {{ lead.status }}
                    </q-badge>
                  </div>

                  <div class="text-weight-bold">{{ lead.client?.name }}</div>
                  <div class="text-caption text-grey-7 q-mt-xs ellipsis">
                    {{ lead.property?.title }}
                  </div>

                  <q-separator class="q-my-sm" />

                  <div class="flex items-center justify-between">
                    <div class="text-caption text-grey-7">Probabilidade</div>
                    <div class="text-caption text-weight-bold text-primary">
                      {{ lead.probability }}%
                    </div>
                  </div>
                  <q-linear-progress
                    :value="lead.probability / 100"
                    color="primary"
                    class="q-mt-xs"
                  />

                  <div v-if="lead.next_action_date" class="q-mt-sm">
                    <q-chip dense size="sm" icon="event" color="grey-3" text-color="grey-8">
                      {{ formatDate(lead.next_action_date) }}
                    </q-chip>
                  </div>
                </q-card-section>
              </q-card>

              <div
                v-if="getLeadsByStage(stage.value).length === 0"
                class="text-center q-pa-md text-grey-6"
              >
                Nenhum lead neste estágio
              </div>
            </div>
          </q-scroll-area>
        </div>
      </div>
    </div>

    <!-- Visualização Tabela -->
    <div v-else>
      <q-card>
        <q-table
          :rows="leadStore.leads"
          :columns="columns"
          row-key="id"
          :loading="leadStore.loading"
          :pagination="pagination"
          @request="onRequest"
          flat
          bordered
        >
          <template v-slot:body-cell-client="props">
            <q-td :props="props">
              <div class="flex items-center q-gutter-sm">
                <q-avatar color="primary" text-color="white" size="32px">
                  {{ props.row.client?.name.charAt(0).toUpperCase() }}
                </q-avatar>
                <div>
                  <div class="text-weight-bold">{{ props.row.client?.name }}</div>
                  <div class="text-caption text-grey-7">
                    {{ props.row.client?.phone }}
                  </div>
                </div>
              </div>
            </q-td>
          </template>

          <template v-slot:body-cell-property="props">
            <q-td :props="props">
              <div>
                <div class="text-weight-bold">{{ props.row.property?.title }}</div>
                <div class="text-caption text-grey-7">
                  {{ props.row.property?.city }}, {{ props.row.property?.state }}
                </div>
              </div>
            </q-td>
          </template>

          <template v-slot:body-cell-status="props">
            <q-td :props="props">
              <q-badge :color="getStatusColor(props.row.status)">
                {{ props.row.status }}
              </q-badge>
            </q-td>
          </template>

          <template v-slot:body-cell-stage="props">
            <q-td :props="props">
              <q-badge color="info">{{ props.row.stage }}</q-badge>
            </q-td>
          </template>

          <template v-slot:body-cell-probability="props">
            <q-td :props="props">
              <div class="flex items-center q-gutter-sm">
                <q-linear-progress
                  :value="props.row.probability / 100"
                  color="primary"
                  style="width: 100px"
                />
                <span class="text-weight-bold">{{ props.row.probability }}%</span>
              </div>
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
                @click="$router.push(`/leads/${props.row.id}`)"
              >
                <q-tooltip>Ver detalhes</q-tooltip>
              </q-btn>
              <q-btn flat dense round icon="edit" color="primary" @click="handleEdit(props.row)">
                <q-tooltip>Editar</q-tooltip>
              </q-btn>
            </q-td>
          </template>
        </q-table>
      </q-card>
    </div>

    <!-- Toggle de Visualização -->
    <div class="fixed-bottom-right q-pa-md">
      <q-btn
        round
        color="primary"
        size="lg"
        :icon="viewMode === 'kanban' ? 'table_chart' : 'dashboard'"
        @click="toggleViewMode"
      >
        <q-tooltip>
          {{ viewMode === 'kanban' ? 'Visualização em Tabela' : 'Visualização Kanban' }}
        </q-tooltip>
      </q-btn>
    </div>

    <!-- Dialog Criar Lead -->
    <q-dialog v-model="showLeadDialog" persistent>
      <q-card style="min-width: 500px">
        <q-card-section class="row items-center q-pb-none">
          <div class="text-h6">Criar Lead</div>
          <q-space />
          <q-btn icon="close" flat round dense @click="closeLeadDialog" />
        </q-card-section>

        <q-card-section>
          <q-form @submit="handleCreateLead" class="q-gutter-md">
            <q-select
              v-model="leadForm.client_id"
              label="Cliente *"
              outlined
              dense
              :options="filteredClients"
              option-value="id"
              option-label="name"
              use-input
              @filter="filterClients"
              :rules="[(val) => !!val || 'Cliente é obrigatório']"
            >
              <template v-slot:no-option>
                <q-item>
                  <q-item-section class="text-grey"> Nenhum cliente encontrado </q-item-section>
                </q-item>
              </template>
            </q-select>

            <q-select
              v-model="leadForm.property_id"
              label="Imóvel *"
              outlined
              dense
              :options="filteredProperties"
              option-value="id"
              option-label="title"
              use-input
              @filter="filterProperties"
              :rules="[(val) => !!val || 'Imóvel é obrigatório']"
            >
              <template v-slot:no-option>
                <q-item>
                  <q-item-section class="text-grey"> Nenhum imóvel encontrado </q-item-section>
                </q-item>
              </template>
            </q-select>

            <q-select
              v-model="leadForm.status"
              label="Status"
              outlined
              dense
              :options="statusOptions"
              emit-value
              map-options
            />

            <q-select
              v-model="leadForm.stage"
              label="Estágio"
              outlined
              dense
              :options="stageOptions"
              emit-value
              map-options
            />

            <q-input
              v-model.number="leadForm.probability"
              label="Probabilidade (%)"
              outlined
              dense
              type="number"
              min="0"
              max="100"
            />

            <q-input
              v-model="leadForm.notes"
              label="Observações"
              outlined
              type="textarea"
              rows="3"
            />

            <div class="row justify-end q-gutter-md">
              <q-btn flat label="Cancelar" @click="closeLeadDialog" />
              <q-btn
                type="submit"
                color="primary"
                label="Criar Lead"
                :loading="leadStore.loading"
              />
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </q-dialog>

    <!-- Dialog Editar Lead -->
    <q-dialog v-model="showEditDialog" persistent>
      <q-card style="min-width: 500px">
        <q-card-section class="row items-center q-pb-none">
          <div class="text-h6">Editar Lead</div>
          <q-space />
          <q-btn icon="close" flat round dense @click="showEditDialog = false" />
        </q-card-section>

        <q-card-section>
          <q-form @submit="handleUpdateLead" class="q-gutter-md">
            <q-select
              v-model="editForm.status"
              label="Status"
              outlined
              dense
              :options="statusOptions"
              emit-value
              map-options
            />

            <q-select
              v-model="editForm.stage"
              label="Estágio"
              outlined
              dense
              :options="stageOptions"
              emit-value
              map-options
            />

            <q-input
              v-model.number="editForm.probability"
              label="Probabilidade (%)"
              outlined
              dense
              type="number"
              min="0"
              max="100"
            />

            <q-input
              v-model="editForm.notes"
              label="Observações"
              outlined
              type="textarea"
              rows="3"
            />

            <div class="row justify-end q-gutter-md">
              <q-btn flat label="Cancelar" @click="showEditDialog = false" />
              <q-btn type="submit" color="primary" label="Atualizar" :loading="leadStore.loading" />
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import { useLeadStore } from '@stores/lead';
import { useClientStore } from '@stores/client';
import { usePropertyStore } from '@stores/property';
import { useQuasar } from 'quasar';
import StatCard from '@components/StatCard.vue';
import { Lead, LeadStatus, Client, Property } from '@types/index';

const router = useRouter();
const leadStore = useLeadStore();
const clientStore = useClientStore();
const propertyStore = usePropertyStore();
const $q = useQuasar();

const showLeadDialog = ref(false);
const showEditDialog = ref(false);
const viewMode = ref<'kanban' | 'table'>('kanban');
const metricsLoading = ref(false);
const editingLead = ref<Lead | null>(null);

const filteredClients = ref<Client[]>([]);
const filteredProperties = ref<Property[]>([]);

const filters = reactive({
  status: null,
  stage: null,
  search: '',
});

const leadForm = reactive({
  client_id: '',
  property_id: '',
  status: 'novo',
  stage: 'prospeccao',
  probability: 10,
  notes: '',
});

const editForm = reactive({
  status: '',
  stage: '',
  probability: 0,
  notes: '',
});

const pagination = ref({
  sortBy: 'createdAt',
  descending: true,
  page: 1,
  rowsPerPage: 10,
  rowsNumber: 0,
});

const columns = [
  {
    name: 'client',
    label: 'Cliente',
    align: 'left',
    field: 'client',
    sortable: true,
  },
  {
    name: 'property',
    label: 'Imóvel',
    align: 'left',
    field: 'property',
    sortable: true,
  },
  {
    name: 'status',
    label: 'Status',
    align: 'center',
    field: 'status',
    sortable: true,
  },
  {
    name: 'stage',
    label: 'Estágio',
    align: 'center',
    field: 'stage',
    sortable: true,
  },
  {
    name: 'probability',
    label: 'Probabilidade',
    align: 'center',
    field: 'probability',
    sortable: true,
  },
  {
    name: 'actions',
    label: 'Ações',
    align: 'center',
  },
];

const statusOptions = [
  { label: 'Novo', value: 'novo' },
  { label: 'Contatado', value: 'contatado' },
  { label: 'Visitou', value: 'visitou' },
  { label: 'Interessado', value: 'interessado' },
  { label: 'Negociando', value: 'negociando' },
  { label: 'Concluído', value: 'concluido' },
  { label: 'Perdido', value: 'perdido' },
];

const stageOptions = [
  { label: 'Prospecção', value: 'prospeccao' },
  { label: 'Qualificação', value: 'qualificacao' },
  { label: 'Apresentação', value: 'apresentacao' },
  { label: 'Negociação', value: 'negociacao' },
  { label: 'Fechamento', value: 'fechamento' },
];

const stages = [
  { label: 'Prospecção', value: 'prospeccao', color: '#2196F3' },
  { label: 'Qualificação', value: 'qualificacao', color: '#00BCD4' },
  { label: 'Apresentação', value: 'apresentacao', color: '#4CAF50' },
  { label: 'Negociação', value: 'negociacao', color: '#FF9800' },
  { label: 'Fechamento', value: 'fechamento', color: '#9C27B0' },
];

const getLeadsByStage = (stage: string) => {
  return leadStore.leads.filter((lead) => lead.stage === stage);
};

const getStatusColor = (status: LeadStatus): string => {
  const colors: Record<LeadStatus, string> = {
    novo: 'blue',
    contatado: 'cyan',
    visitou: 'teal',
    interessado: 'green',
    negociando: 'orange',
    concluido: 'positive',
    perdido: 'negative',
  };
  return colors[status] || 'grey';
};

const formatDate = (date: string): string => {
  return new Date(date).toLocaleDateString('pt-BR');
};

const toggleViewMode = () => {
  viewMode.value = viewMode.value === 'kanban' ? 'table' : 'kanban';
};

const handleFilter = async () => {
  leadStore.page = 1;
  await leadStore.fetchAll({
    status: filters.status,
    stage: filters.stage,
  });
  pagination.value.rowsNumber = leadStore.total;
};

const clearFilters = () => {
  filters.status = null;
  filters.stage = null;
  filters.search = '';
  handleFilter();
};

const onRequest = async (props: any) => {
  const { page, rowsPerPage } = props.pagination;
  leadStore.page = page;
  leadStore.limit = rowsPerPage;
  await leadStore.fetchAll({
    status: filters.status,
    stage: filters.stage,
  });
  pagination.value.rowsNumber = leadStore.total;
};

const filterClients = (val: string, update: Function) => {
  if (val === '') {
    update(() => {
      filteredClients.value = clientStore.clients;
    });
    return;
  }

  update(() => {
    const needle = val.toLowerCase();
    filteredClients.value = clientStore.clients.filter((c) =>
      c.name.toLowerCase().includes(needle),
    );
  });
};

const filterProperties = (val: string, update: Function) => {
  if (val === '') {
    update(() => {
      filteredProperties.value = propertyStore.properties;
    });
    return;
  }

  update(() => {
    const needle = val.toLowerCase();
    filteredProperties.value = propertyStore.properties.filter((p) =>
      p.title.toLowerCase().includes(needle),
    );
  });
};

const handleCreateLead = async () => {
  await leadStore.create(leadForm);
  closeLeadDialog();
  await loadData();
};

const handleEdit = (lead: Lead) => {
  editingLead.value = lead;
  Object.assign(editForm, {
    status: lead.status,
    stage: lead.stage,
    probability: lead.probability,
    notes: lead.notes,
  });
  showEditDialog.value = true;
};

const handleUpdateLead = async () => {
  if (editingLead.value) {
    await leadStore.updateStatus(editingLead.value.id, editForm);
    showEditDialog.value = false;
    editingLead.value = null;
    await loadData();
  }
};

const closeLeadDialog = () => {
  showLeadDialog.value = false;
  Object.assign(leadForm, {
    client_id: '',
    property_id: '',
    status: 'novo',
    stage: 'prospeccao',
    probability: 10,
    notes: '',
  });
};

const loadData = async () => {
  metricsLoading.value = true;
  await Promise.all([
    leadStore.fetchAll(),
    leadStore.fetchMetrics(),
    clientStore.fetchAll(),
    propertyStore.fetchAll(),
  ]);
  metricsLoading.value = false;

  filteredClients.value = clientStore.clients;
  filteredProperties.value = propertyStore.properties;
  pagination.value.rowsNumber = leadStore.total;
};

onMounted(() => {
  loadData();
});
</script>

<style scoped lang="scss">
.kanban-container {
  min-height: 500px;
}

.kanban-column {
  background-color: #f5f5f5;
  border-radius: 8px;
  overflow: hidden;
  height: calc(100vh - 400px);
  display: flex;
  flex-direction: column;
}

.kanban-header {
  padding: 12px 16px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: var(--q-primary);
}

.kanban-cards {
  flex: 1;
  height: 100%;
}

.lead-card {
  transition: all 0.3s ease;
  border-left: 4px solid var(--q-primary);

  &:hover {
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    transform: translateY(-2px);
  }
}

.fixed-bottom-right {
  position: fixed;
  bottom: 0;
  right: 0;
  z-index: 1000;
}

.ellipsis {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
<template>
  <q-page class="q-pa-md">
    <div class="row items-center q-mb-lg">
      <div class="col">
        <q-btn flat dense round icon="arrow_back" @click="$router.back()" />
      </div>
      <div class="col-auto">
        <q-btn color="primary" label="Editar" icon="edit" @click="showEditDialog = true" />
      </div>
    </div>

    <div v-if="leadStore.loading" class="text-center q-pa-xl">
      <q-spinner color="primary" size="50px" />
    </div>

    <div v-else-if="!currentLead" class="text-center q-pa-xl">
      <q-icon name="trending_up" size="80px" color="grey-5" />
      <p class="text-h6 text-grey-6 q-mt-md">Lead não encontrado</p>
    </div>

    <div v-else class="row q-col-gutter-lg">
      <!-- Informações Principais -->
      <div class="col-xs-12 col-md-8">
        <!-- Cabeçalho do Lead -->
        <q-card class="q-mb-md">
          <q-card-section>
            <div class="row items-center q-mb-md">
              <div class="col">
                <div class="text-h5 text-weight-bold">
                  Lead #{{ currentLead.id.substring(0, 8) }}
                </div>
                <div class="text-subtitle2 text-grey-7">
                  Criado em {{ formatDate(currentLead.createdAt) }}
                </div>
              </div>
              <div class="col-auto">
                <q-badge :color="getStatusColor(currentLead.status)" class="q-pa-sm">
                  {{ currentLead.status }}
                </q-badge>
              </div>
            </div>

            <q-separator class="q-my-md" />

            <!-- Informações do Cliente -->
            <div class="q-mb-md">
              <div class="text-subtitle1 text-weight-bold q-mb-sm">Cliente</div>
              <div class="flex items-center q-gutter-md">
                <q-avatar color="primary" text-color="white" size="56px">
                  {{ currentLead.client?.name.charAt(0).toUpperCase() }}
                </q-avatar>
                <div>
                  <div class="text-h6 text-weight-bold">
                    {{ currentLead.client?.name }}
                  </div>
                  <div class="text-subtitle2 text-grey-7">
                    {{ currentLead.client?.email }}
                  </div>
                  <div class="text-subtitle2 text-grey-7">
                    {{ currentLead.client?.phone }}
                  </div>
                </div>
                <q-space />
                <q-btn
                  flat
                  dense
                  round
                  icon="visibility"
                  color="primary"
                  @click="$router.push(`/clients/${currentLead.client?.id}`)"
                >
                  <q-tooltip>Ver cliente</q-tooltip>
                </q-btn>
              </div>
            </div>

            <q-separator class="q-my-md" />

            <!-- Informações do Imóvel -->
            <div class="q-mb-md">
              <div class="text-subtitle1 text-weight-bold q-mb-sm">Imóvel de Interesse</div>
              <div class="flex items-center q-gutter-md">
                <q-img
                  v-if="currentLead.property?.images?.[0]"
                  :src="currentLead.property.images[0].url"
                  style="width: 80px; height: 80px; border-radius: 8px"
                />
                <q-avatar v-else color="grey-3" text-color="grey-7" size="80px" icon="home" />
                <div class="flex-1">
                  <div class="text-h6 text-weight-bold">
                    {{ currentLead.property?.title }}
                  </div>
                  <div class="text-subtitle2 text-grey-7">
                    {{ currentLead.property?.city }}, {{ currentLead.property?.state }}
                  </div>
                  <div class="text-subtitle2 text-primary text-weight-bold">
                    {{ formatCurrency(currentLead.property?.price_sale || 0) }}
                  </div>
                </div>
                <q-btn
                  flat
                  dense
                  round
                  icon="visibility"
                  color="primary"
                  @click="$router.push(`/properties/${currentLead.property?.id}`)"
                >
                  <q-tooltip>Ver imóvel</q-tooltip>
                </q-btn>
              </div>
            </div>

            <q-separator class="q-my-md" />

            <!-- Status e Estágio -->
            <div class="row q-col-gutter-md">
              <div class="col-xs-12 col-md-4">
                <div class="text-subtitle2 text-weight-bold q-mb-xs">Estágio</div>
                <q-badge color="info" class="q-pa-sm">{{ currentLead.stage }}</q-badge>
              </div>
              <div class="col-xs-12 col-md-4">
                <div class="text-subtitle2 text-weight-bold q-mb-xs">Probabilidade</div>
                <div class="flex items-center q-gutter-sm">
                  <q-linear-progress
                    :value="currentLead.probability / 100"
                    color="primary"
                    size="12px"
                    rounded
                    style="width: 100px"
                  />
                  <span class="text-weight-bold">{{ currentLead.probability }}%</span>
                </div>
              </div>
              <div class="col-xs-12 col-md-4">
                <div class="text-subtitle2 text-weight-bold q-mb-xs">Corretor</div>
                <div class="text-grey-8">{{ currentLead.user?.name }}</div>
              </div>
            </div>
          </q-card-section>
        </q-card>

        <!-- Próxima Ação -->
        <q-card v-if="currentLead.next_action_date" class="q-mb-md">
          <q-card-section>
            <div class="flex items-center justify-between">
              <div>
                <div class="text-subtitle1 text-weight-bold">Próxima Ação</div>
                <div class="text-grey-8 q-mt-xs">{{ currentLead.next_action }}</div>
                <div class="text-caption text-grey-7 q-mt-xs">
                  <q-icon name="event" size="16px" />
                  {{ formatDateTime(currentLead.next_action_date) }}
                </div>
              </div>
              <q-btn
                flat
                color="primary"
                label="Reagendar"
                icon="edit"
                @click="showScheduleDialog = true"
              />
            </div>
          </q-card-section>
        </q-card>

        <!-- Observações -->
        <q-card class="q-mb-md">
          <q-card-section>
            <div class="flex justify-between items-center q-mb-md">
              <div class="text-subtitle1 text-weight-bold">Observações</div>
              <q-btn
                flat
                dense
                label="Adicionar Nota"
                icon="add"
                color="primary"
                @click="showNoteDialog = true"
              />
            </div>
            <div v-if="currentLead.notes" class="text-grey-8" style="white-space: pre-line">
              {{ currentLead.notes }}
            </div>
            <div v-else class="text-grey-6 text-center q-pa-md">Nenhuma observação registrada</div>
          </q-card-section>
        </q-card>

        <!-- Histórico de Atividades -->
        <q-card>
          <q-card-section>
            <div class="text-subtitle1 text-weight-bold q-mb-md">Histórico de Atividades</div>

            <q-timeline
              v-if="currentLead.history && currentLead.history.length > 0"
              color="primary"
            >
              <q-timeline-entry
                v-for="item in currentLead.history"
                :key="item.id"
                :title="item.action"
                :subtitle="formatDateTime(item.createdAt)"
                :icon="getHistoryIcon(item.action)"
              >
                <div v-if="item.description" class="text-grey-8">
                  {{ item.description }}
                </div>
                <div v-if="item.old_value && item.new_value" class="q-mt-xs">
                  <q-chip dense size="sm" color="grey-3" text-color="grey-8">
                    De: {{ item.old_value }}
                  </q-chip>
                  <q-icon name="arrow_forward" size="16px" class="q-mx-xs" />
                  <q-chip dense size="sm" color="primary" text-color="white">
                    Para: {{ item.new_value }}
                  </q-chip>
                </div>
              </q-timeline-entry>
            </q-timeline>

            <div v-else class="text-center text-grey-6 q-pa-md">
              <q-icon name="history" size="48px" color="grey-5" />
              <p class="q-mt-md">Nenhuma atividade registrada</p>
            </div>
          </q-card-section>
        </q-card>
      </div>

      <!-- Sidebar - Ações Rápidas -->
      <div class="col-xs-12 col-md-4">
        <!-- Ações Rápidas -->
        <q-card class="q-mb-md">
          <q-card-section class="q-gutter-md">
            <q-btn
              color="primary"
              label="Agendar Visita"
              icon="event"
              class="full-width"
              @click="showScheduleDialog = true"
            />
            <q-btn
              flat
              color="primary"
              label="Adicionar Nota"
              icon="note_add"
              class="full-width"
              @click="showNoteDialog = true"
            />
            <q-btn
              flat
              color="primary"
              label="Contatar Cliente"
              icon="phone"
              class="full-width"
              @click="handleContact"
            />
            <q-btn
              flat
              color="primary"
              label="Enviar WhatsApp"
              icon="chat"
              class="full-width"
              @click="handleWhatsApp"
            />
          </q-card-section>
        </q-card>

        <!-- Alterar Status -->
        <q-card class="q-mb-md">
          <q-card-section>
            <div class="text-subtitle1 text-weight-bold q-mb-md">Alterar Status</div>
            <div class="q-gutter-sm">
              <q-btn
                v-for="status in quickStatusOptions"
                :key="status.value"
                :color="status.color"
                :label="status.label"
                :icon="status.icon"
                class="full-width"
                @click="handleQuickStatusChange(status.value)"
              />
            </div>
          </q-card-section>
        </q-card>

        <!-- Estatísticas -->
        <q-card>
          <q-card-section>
            <div class="text-subtitle1 text-weight-bold q-mb-md">Estatísticas</div>
            <div class="q-gutter-md">
              <div>
                <div class="text-caption text-grey-7">Tempo no Pipeline</div>
                <div class="text-h6 text-weight-bold">
                  {{ calculateDaysInPipeline(currentLead.createdAt) }} dias
                </div>
              </div>
              <div>
                <div class="text-caption text-grey-7">Última Atualização</div>
                <div class="text-grey-8">{{ formatDate(currentLead.updatedAt) }}</div>
              </div>
              <div>
                <div class="text-caption text-grey-7">Total de Atividades</div>
                <div class="text-h6 text-weight-bold">
                  {{ currentLead.history?.length || 0 }}
                </div>
              </div>
            </div>
          </q-card-section>
        </q-card>
      </div>
    </div>

    <!-- Dialog Editar Lead -->
    <q-dialog v-model="showEditDialog" persistent>
      <q-card style="min-width: 500px">
        <q-card-section class="row items-center q-pb-none">
          <div class="text-h6">Editar Lead</div>
          <q-space />
          <q-btn icon="close" flat round dense @click="showEditDialog = false" />
        </q-card-section>

        <q-card-section>
          <q-form @submit="handleUpdate" class="q-gutter-md">
            <q-select
              v-model="editForm.status"
              label="Status"
              outlined
              dense
              :options="statusOptions"
              emit-value
              map-options
            />

            <q-select
              v-model="editForm.stage"
              label="Estágio"
              outlined
              dense
              :options="stageOptions"
              emit-value
              map-options
            />

            <q-input
              v-model.number="editForm.probability"
              label="Probabilidade (%)"
              outlined
              dense
              type="number"
              min="0"
              max="100"
            />

            <q-input
              v-model="editForm.notes"
              label="Observações"
              outlined
              type="textarea"
              rows="3"
            />

            <div class="row justify-end q-gutter-md">
              <q-btn flat label="Cancelar" @click="showEditDialog = false" />
              <q-btn type="submit" color="primary" label="Atualizar" :loading="leadStore.loading" />
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </q-dialog>

    <!-- Dialog Agendar Visita -->
    <q-dialog v-model="showScheduleDialog" persistent>
      <q-card style="min-width: 400px">
        <q-card-section class="row items-center q-pb-none">
          <div class="text-h6">Agendar Visita</div>
          <q-space />
          <q-btn icon="close" flat round dense @click="showScheduleDialog = false" />
        </q-card-section>

        <q-card-section>
          <q-form @submit="handleScheduleVisit" class="q-gutter-md">
            <q-input
              v-model="scheduleForm.date"
              label="Data e Hora *"
              outlined
              dense
              type="datetime-local"
              :rules="[(val) => !!val || 'Data é obrigatória']"
            />

            <q-input
              v-model="scheduleForm.action"
              label="Descrição da Ação"
              outlined
              dense
              placeholder="Ex: Visita ao imóvel"
            />

            <div class="row justify-end q-gutter-md">
              <q-btn flat label="Cancelar" @click="showScheduleDialog = false" />
              <q-btn type="submit" color="primary" label="Agendar" :loading="leadStore.loading" />
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </q-dialog>

    <!-- Dialog Adicionar Nota -->
    <q-dialog v-model="showNoteDialog" persistent>
      <q-card style="min-width: 400px">
        <q-card-section class="row items-center q-pb-none">
          <div class="text-h6">Adicionar Nota</div>
          <q-space />
          <q-btn icon="close" flat round dense @click="showNoteDialog = false" />
        </q-card-section>

        <q-card-section>
          <q-form @submit="handleAddNote" class="q-gutter-md">
            <q-input
              v-model="noteForm.note"
              label="Nota *"
              outlined
              type="textarea"
              rows="5"
              :rules="[(val) => !!val || 'Nota é obrigatória']"
            />

            <div class="row justify-end q-gutter-md">
              <q-btn flat label="Cancelar" @click="showNoteDialog = false" />
              <q-btn type="submit" color="primary" label="Adicionar" :loading="leadStore.loading" />
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useLeadStore } from '@stores/lead';
import { useQuasar } from 'quasar';
import { LeadStatus } from '@types/index';

const route = useRoute();
const router = useRouter();
const leadStore = useLeadStore();
const $q = useQuasar();

const showEditDialog = ref(false);
const showScheduleDialog = ref(false);
const showNoteDialog = ref(false);

const editForm = reactive({
  status: '',
  stage: '',
  probability: 0,
  notes: '',
});

const scheduleForm = reactive({
  date: '',
  action: 'Visita ao imóvel',
});

const noteForm = reactive({
  note: '',
});

const statusOptions = [
  { label: 'Novo', value: 'novo' },
  { label: 'Contatado', value: 'contatado' },
  { label: 'Visitou', value: 'visitou' },
  { label: 'Interessado', value: 'interessado' },
  { label: 'Negociando', value: 'negociando' },
  { label: 'Concluído', value: 'concluido' },
  { label: 'Perdido', value: 'perdido' },
];

const stageOptions = [
  { label: 'Prospecção', value: 'prospeccao' },
  { label: 'Qualificação', value: 'qualificacao' },
  { label: 'Apresentação', value: 'apresentacao' },
  { label: 'Negociação', value: 'negociacao' },
  { label: 'Fechamento', value: 'fechamento' },
];

const quickStatusOptions = [
  { label: 'Marcar como Contatado', value: 'contatado', color: 'cyan', icon: 'phone' },
  {
    label: 'Marcar como Interessado',
    value: 'interessado',
    color: 'green',
    icon: 'favorite',
  },
  {
    label: 'Marcar como Negociando',
    value: 'negociando',
    color: 'orange',
    icon: 'handshake',
  },
  {
    label: 'Marcar como Concluído',
    value: 'concluido',
    color: 'positive',
    icon: 'check_circle',
  },
  { label: 'Marcar como Perdido', value: 'perdido', color: 'negative', icon: 'cancel' },
];

const currentLead = computed(() => leadStore.currentLead);

const getStatusColor = (status: LeadStatus): string => {
  const colors: Record<LeadStatus, string> = {
    novo: 'blue',
    contatado: 'cyan',
    visitou: 'teal',
    interessado: 'green',
    negociando: 'orange',
    concluido: 'positive',
    perdido: 'negative',
  };
  return colors[status] || 'grey';
};

const getHistoryIcon = (action: string): string => {
  const icons: Record<string, string> = {
    criacao: 'add_circle',
    mudanca_status: 'swap_horiz',
    mudanca_stage: 'trending_up',
    agendamento_visita: 'event',
    adicionar_nota: 'note_add',
  };
  return icons[action] || 'circle';
};

const formatDate = (date: string | undefined): string => {
  if (!date) return 'N/A';
  return new Date(date).toLocaleDateString('pt-BR');
};

const formatDateTime = (date: string | undefined): string => {
  if (!date) return 'N/A';
  return new Date(date).toLocaleString('pt-BR');
};

const formatCurrency = (value: number): string => {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL',
  }).format(value);
};

const calculateDaysInPipeline = (createdAt: string | undefined): number => {
  if (!createdAt) return 0;
  const created = new Date(createdAt);
  const now = new Date();
  const diff = now.getTime() - created.getTime();
  return Math.floor(diff / (1000 * 60 * 60 * 24));
};

const handleUpdate = async () => {
  if (currentLead.value) {
    await leadStore.updateStatus(currentLead.value.id, editForm);
    showEditDialog.value = false;
    await leadStore.fetchById(currentLead.value.id);
  }
};

const handleQuickStatusChange = async (status: string) => {
  if (currentLead.value) {
    await leadStore.updateStatus(currentLead.value.id, { status });
    await leadStore.fetchById(currentLead.value.id);
  }
};

const handleScheduleVisit = async () => {
  if (currentLead.value) {
    await leadStore.scheduleVisit(currentLead.value.id, scheduleForm.date, scheduleForm.action);
    showScheduleDialog.value = false;
    scheduleForm.date = '';
    scheduleForm.action = 'Visita ao imóvel';
    await leadStore.fetchById(currentLead.value.id);
  }
};

const handleAddNote = async () => {
  if (currentLead.value) {
    await leadStore.addNote(currentLead.value.id, noteForm.note);
    showNoteDialog.value = false;
    noteForm.note = '';
    await leadStore.fetchById(currentLead.value.id);
  }
};

const handleContact = () => {
  if (currentLead.value?.client?.phone) {
    window.location.href = `tel:${currentLead.value.client.phone}`;
  }
};

const handleWhatsApp = () => {
  if (currentLead.value?.client?.phone) {
    const phone = currentLead.value.client.phone.replace(/\D/g, '');
    const message = encodeURIComponent(
      `Olá ${currentLead.value.client.name}! Gostaria de falar sobre o imóvel: ${currentLead.value.property?.title}`,
    );
    window.open(`https://wa.me/55${phone}?text=${message}`, '_blank');
  }
};

const loadLead = async () => {
  const leadId = route.params.id as string;
  await leadStore.fetchById(leadId);

  if (currentLead.value) {
    Object.assign(editForm, {
      status: currentLead.value.status,
      stage: currentLead.value.stage,
      probability: currentLead.value.probability,
      notes: currentLead.value.notes,
    });
  }
};

onMounted(() => {
  loadLead();
});
</script>

<style scoped lang="scss">
.q-timeline {
  padding: 0;
}
</style>
