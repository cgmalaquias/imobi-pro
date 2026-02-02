<template>
  <q-page class="q-pa-md">
    <div class="text-h4 q-mb-md">Dashboard</div>

    <!-- Cards de estatísticas -->
    <div class="row q-col-gutter-md q-mb-md">
      <div class="col-12 col-md-3">
        <q-card class="bg-primary text-white">
          <q-card-section>
            <div class="flex items-center justify-between">
              <div>
                <div class="text-caption">Total de Imóveis</div>
                <div class="text-h4">{{ stats.totalProperties }}</div>
              </div>
              <q-icon name="home_work" size="48px" />
            </div>
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-md-3">
        <q-card class="bg-positive text-white">
          <q-card-section>
            <div class="flex items-center justify-between">
              <div>
                <div class="text-caption">Disponíveis</div>
                <div class="text-h4">{{ stats.availableProperties }}</div>
              </div>
              <q-icon name="check_circle" size="48px" />
            </div>
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-md-3">
        <q-card class="bg-warning text-white">
          <q-card-section>
            <div class="flex items-center justify-between">
              <div>
                <div class="text-caption">Visitas Pendentes</div>
                <div class="text-h4">{{ stats.pendingVisits }}</div>
              </div>
              <q-icon name="event" size="48px" />
            </div>
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-md-3">
        <q-card class="bg-info text-white">
          <q-card-section>
            <div class="flex items-center justify-between">
              <div>
                <div class="text-caption">Visitas Hoje</div>
                <div class="text-h4">{{ stats.todayVisits }}</div>
              </div>
              <q-icon name="today" size="48px" />
            </div>
          </q-card-section>
        </q-card>
      </div>
    </div>

    <!-- Gráficos e informações -->
    <div class="row q-col-gutter-md q-mb-md">
      <!-- Imóveis por tipo -->
      <div class="col-12 col-md-6">
        <q-card>
          <q-card-section>
            <div class="text-h6 q-mb-md">Imóveis por Tipo</div>
            <div v-if="stats.propertiesByType && stats.propertiesByType.length > 0">
              <div v-for="item in stats.propertiesByType" :key="item.type" class="q-mb-sm">
                <div class="flex items-center justify-between q-mb-xs">
                  <span>{{ getTypeLabel(item.type) }}</span>
                  <span class="text-bold">{{ item.count }}</span>
                </div>
                <q-linear-progress
                  :value="item.count / stats.totalProperties"
                  color="primary"
                  size="12px"
                />
              </div>
            </div>
            <div v-else class="text-center text-grey-7 q-pa-md">Nenhum dado disponível</div>
          </q-card-section>
        </q-card>
      </div>

      <!-- Imóveis por status -->
      <div class="col-12 col-md-6">
        <q-card>
          <q-card-section>
            <div class="text-h6 q-mb-md">Imóveis por Status</div>
            <div v-if="stats.propertiesByStatus && stats.propertiesByStatus.length > 0">
              <div v-for="item in stats.propertiesByStatus" :key="item.status" class="q-mb-sm">
                <div class="flex items-center justify-between q-mb-xs">
                  <span>{{ getStatusLabel(item.status) }}</span>
                  <span class="text-bold">{{ item.count }}</span>
                </div>
                <q-linear-progress
                  :value="item.count / stats.totalProperties"
                  :color="getStatusColor(item.status)"
                  size="12px"
                />
              </div>
            </div>
            <div v-else class="text-center text-grey-7 q-pa-md">Nenhum dado disponível</div>
          </q-card-section>
        </q-card>
      </div>
    </div>

    <!-- Últimas visitas -->
    <div class="row q-col-gutter-md">
      <div class="col-12">
        <q-card>
          <q-card-section>
            <div class="row items-center q-mb-md">
              <div class="col">
                <div class="text-h6">Últimas Visitas Agendadas</div>
              </div>
              <div class="col-auto">
                <q-btn label="Ver todas" color="primary" flat to="/admin/leads" />
              </div>
            </div>

            <q-list separator v-if="recentVisits.length > 0">
              <q-item v-for="visit in recentVisits" :key="visit.id">
                <q-item-section avatar>
                  <q-avatar icon="event" color="primary" text-color="white" />
                </q-item-section>

                <q-item-section>
                  <q-item-label>{{ visit.name }}</q-item-label>
                  <q-item-label caption>
                    {{ visit.property?.title || 'Imóvel não encontrado' }}
                  </q-item-label>
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

            <div v-else class="text-center text-grey-7 q-pa-md">Nenhuma visita agendada</div>
          </q-card-section>
        </q-card>
      </div>
    </div>

    <!-- Loading -->
    <q-inner-loading :showing="loading">
      <q-spinner-gears size="50px" color="primary" />
    </q-inner-loading>
  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { api } from 'src/boot/api';
import type { Visit } from 'src/services/visit.service';

const loading = ref(false);

const stats = ref({
  totalProperties: 0,
  availableProperties: 0,
  pendingVisits: 0,
  todayVisits: 0,
  propertiesByType: [] as Array<{ type: string; count: number }>,
  propertiesByStatus: [] as Array<{ status: string; count: number }>,
});

const recentVisits = ref<Visit[]>([]);

const loadDashboard = async () => {
  loading.value = true;

  try {
    // Carregar estatísticas de imóveis
    const propertiesResponse = await api.get('/properties?status=DISPONIVEL');
    const allPropertiesResponse = await api.get('/properties');

    stats.value.totalProperties = allPropertiesResponse.total || 0;
    stats.value.availableProperties = propertiesResponse.total || 0;

    // Agrupar por tipo
    const typeMap = new Map<string, number>();
    allPropertiesResponse.data.forEach((property: any) => {
      const count = typeMap.get(property.type) || 0;
      typeMap.set(property.type, count + 1);
    });

    stats.value.propertiesByType = Array.from(typeMap.entries()).map(([type, count]) => ({
      type,
      count,
    }));

    // Agrupar por status
    const statusMap = new Map<string, number>();
    allPropertiesResponse.data.forEach((property: any) => {
      const count = statusMap.get(property.status) || 0;
      statusMap.set(property.status, count + 1);
    });

    stats.value.propertiesByStatus = Array.from(statusMap.entries()).map(([status, count]) => ({
      status,
      count,
    }));

    // Carregar visitas
    const visitsResponse = await api.get('/visits?status=PENDENTE');
    stats.value.pendingVisits = visitsResponse.total || 0;

    // Visitas de hoje
    const today = new Date().toISOString().split('T')[0];
    const todayVisitsResponse = await api.get(`/visits`);

    const todayVisitsFiltered =
      todayVisitsResponse.length > 0
        ? todayVisitsResponse.data.filter((visit: Visit) => {
            return visit.date === today;
          })
        : [];
    stats.value.todayVisits = todayVisitsFiltered.length;

    // Últimas 5 visitas
    recentVisits.value = visitsResponse.length > 0 ? visitsResponse.data.slice(0, 5) : [];
  } catch (error) {
    console.log('Erro ao carregar dashboard:', error);
  } finally {
    loading.value = false;
  }
};

const formatDate = (date: string) => {
  return new Intl.DateTimeFormat('pt-BR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
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
  await loadDashboard();
});
</script>

<style scoped>
.q-linear-progress {
  border-radius: 4px;
}
</style>
