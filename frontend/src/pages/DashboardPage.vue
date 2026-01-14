<script setup lang="ts">
import { computed, onMounted } from 'vue';
import { usePropertyStore } from 'src/stores/property';
import { useLeadStore } from 'src/stores/lead';
import { useClientStore } from 'src/stores/client';

const propertyStore = usePropertyStore();
const leadStore = useLeadStore();
const clientStore = useClientStore();

// Tipos de imóveis
const propertyTypes = [
  { label: 'Casas', value: 'CASA', icon: 'home', color: 'primary' },
  { label: 'Apartamentos', value: 'APARTAMENTO', icon: 'apartment', color: 'secondary' },
  { label: 'Terrenos', value: 'TERRENO', icon: 'terrain', color: 'accent' },
  { label: 'Comercial', value: 'COMERCIAL', icon: 'business', color: 'positive' },
  { label: 'Rural', value: 'RURAL', icon: 'agriculture', color: 'warning' }
];

// Estatísticas de imóveis por tipo
const propertyStats = computed(() => {
  return propertyTypes.map((type) => {
    const count = propertyStore.properties.filter((p) => p.type === type.value).length;
    return {
      ...type,
      count
    };
  });
});

// Estatísticas gerais
const stats = computed(() => ({
  totalProperties: propertyStore.properties.length,
  featuredProperties: propertyStore.properties.filter((p) => p.featured).length,
  totalLeads: leadStore.leads.length,
  newLeads: leadStore.leads.filter((l) => l.status === 'NOVO').length,
  totalClients: clientStore.clients.length,
  activeClients: clientStore.clients.filter((c) => c.active).length
}));

// Carregar dados
onMounted(async () => {
  try {
    await Promise.all([
      propertyStore.fetchProperties({ limit: 100 }),
      leadStore.fetchLeads({ limit: 100 }),
      clientStore.fetchClients({ limit: 100 })
    ]);
  } catch (error) {
    console.error('Erro ao carregar dados do dashboard:', error);
  }
});
</script>

<template>
  <q-page padding>
    <div class="q-pa-md">
      <h4 class="q-mb-md">Dashboard</h4>

      <!-- Cards de Estatísticas -->
      <div class="row q-col-gutter-md q-mb-lg">
        <div class="col-12 col-sm-6 col-md-3">
          <q-card>
            <q-card-section>
              <div class="text-h6">Imóveis</div>
              <div class="text-h3 text-primary">{{ stats.totalProperties }}</div>
              <div class="text-caption text-grey">{{ stats.featuredProperties }} em destaque</div>
            </q-card-section>
          </q-card>
        </div>

        <div class="col-12 col-sm-6 col-md-3">
          <q-card>
            <q-card-section>
              <div class="text-h6">Leads</div>
              <div class="text-h3 text-secondary">{{ stats.totalLeads }}</div>
              <div class="text-caption text-grey">{{ stats.newLeads }} novos</div>
            </q-card-section>
          </q-card>
        </div>

        <div class="col-12 col-sm-6 col-md-3">
          <q-card>
            <q-card-section>
              <div class="text-h6">Clientes</div>
              <div class="text-h3 text-accent">{{ stats.totalClients }}</div>
              <div class="text-caption text-grey">{{ stats.activeClients }} ativos</div>
            </q-card-section>
          </q-card>
        </div>

        <div class="col-12 col-sm-6 col-md-3">
          <q-card>
            <q-card-section>
              <div class="text-h6">Taxa de Conversão</div>
              <div class="text-h3 text-positive">0%</div>
              <div class="text-caption text-grey">Últimos 30 dias</div>
            </q-card-section>
          </q-card>
        </div>
      </div>

      <!-- Imóveis por Tipo -->
      <div class="row q-col-gutter-md">
        <div class="col-12">
          <q-card>
            <q-card-section>
              <div class="text-h6 q-mb-md">Imóveis por Tipo</div>
              <div class="row q-col-gutter-sm">
                <div
                  v-for="stat in propertyStats"
                  :key="stat.value"
                  class="col-12 col-sm-6 col-md-4"
                >
                  <q-card flat bordered>
                    <q-card-section horizontal>
                      <q-card-section class="col-3 flex flex-center">
                        <q-icon
                          :name="stat.icon"
                          :color="stat.color"
                          size="48px"
                        />
                      </q-card-section>
                      <q-card-section class="col-9">
                        <div class="text-subtitle1">{{ stat.label }}</div>
                        <div class="text-h4 text-weight-bold">{{ stat.count }}</div>
                      </q-card-section>
                    </q-card-section>
                  </q-card>
                </div>
              </div>
            </q-card-section>
          </q-card>
        </div>
      </div>
    </div>
  </q-page>
</template>
