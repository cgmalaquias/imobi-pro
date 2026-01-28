<template>
  <q-page class="q-pa-md">
    <div class="row items-center q-mb-md">
      <div class="col">
        <div class="text-h4">Imóveis</div>
      </div>
      <div class="col-auto">
        <q-btn label="Novo Imóvel" color="primary" icon="add" to="/admin/properties/create" />
      </div>
    </div>

    <!-- Filtros -->
    <q-card class="q-mb-md">
      <q-card-section>
        <div class="row q-col-gutter-md">
          <div class="col-12 col-md-3">
            <q-select
              v-model="filters.type"
              :options="propertyTypes"
              label="Tipo"
              outlined
              dense
              clearable
              @update:model-value="loadProperties"
            />
          </div>

          <div class="col-12 col-md-3">
            <q-select
              v-model="filters.status"
              :options="propertyStatuses"
              label="Status"
              outlined
              dense
              clearable
              @update:model-value="loadProperties"
            />
          </div>

          <div class="col-12 col-md-3">
            <q-input
              v-model="filters.city"
              label="Cidade"
              outlined
              dense
              clearable
              @update:model-value="loadProperties"
            />
          </div>

          <div class="col-12 col-md-3">
            <q-input
              v-model="filters.search"
              label="Buscar"
              outlined
              dense
              clearable
              @update:model-value="loadProperties"
            >
              <template v-slot:prepend>
                <q-icon name="search" />
              </template>
            </q-input>
          </div>
        </div>
      </q-card-section>
    </q-card>

    <!-- Tabela de imóveis -->
    <q-card>
      <q-table
        :rows="properties"
        :columns="columns"
        row-key="id"
        :loading="loading"
        v-model:pagination="pagination"
        @request="loadProperties"
        flat
        bordered
      >
        <template v-slot:body-cell-image="props">
          <q-td :props="props">
            <q-img
              v-if="props.row.images?.[0]"
              :src="props.row.images[0].url"
              style="height: 60px; width: 60px"
              class="rounded-borders"
            />
            <q-icon v-else name="image_not_supported" size="40px" color="grey-5" />
          </q-td>
        </template>

        <template v-slot:body-cell-price="props">
          <q-td :props="props"> R$ {{ formatPrice(props.row.price) }} </q-td>
        </template>

        <template v-slot:body-cell-type="props">
          <q-td :props="props">
            <q-badge :label="getTypeLabel(props.row.type)" color="blue" />
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
              @click="viewProperty(props.row.id)"
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
              @click="editProperty(props.row.id)"
            >
              <q-tooltip>Editar</q-tooltip>
            </q-btn>

            <q-btn
              flat
              dense
              round
              icon="delete"
              color="negative"
              size="sm"
              @click="deleteProperty(props.row.id)"
            >
              <q-tooltip>Deletar</q-tooltip>
            </q-btn>
          </q-td>
        </template>
      </q-table>
    </q-card>

    <!-- Loading -->
    <q-inner-loading :showing="loading">
      <q-spinner-gears size="50px" color="primary" />
    </q-inner-loading>
  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import type { Property, PropertyFilters } from 'src/services/property.service';
import { propertyService } from 'src/services/property.service';

const router = useRouter();
const $q = useQuasar();

const properties = ref<Property[]>([]);
const loading = ref(false);
const filters = ref<PropertyFilters>({});
const pagination = ref({
  sortBy: 'created_at',
  descending: true,
  page: 1,
  rowsPerPage: 10,
  rowsNumber: 0,
});

const columns = [
  {
    name: 'image',
    label: 'Imagem',
    field: 'images',
    align: 'left',
  },
  {
    name: 'title',
    label: 'Título',
    field: 'title',
    align: 'left',
  },
  {
    name: 'type',
    label: 'Tipo',
    field: 'type',
    align: 'left',
  },
  {
    name: 'city',
    label: 'Cidade',
    field: 'city',
    align: 'left',
  },
  {
    name: 'price',
    label: 'Preço',
    field: 'price',
    align: 'right',
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

const propertyTypes = [
  { label: 'Casa', value: 'CASA' },
  { label: 'Apartamento', value: 'APARTAMENTO' },
  { label: 'Comercial', value: 'COMERCIAL' },
  { label: 'Terreno', value: 'TERRENO' },
  { label: 'Fazenda', value: 'FAZENDA' },
];

const propertyStatuses = [
  { label: 'Disponível', value: 'DISPONIVEL' },
  { label: 'Vendido', value: 'VENDIDO' },
  { label: 'Alugado', value: 'ALUGADO' },
];

const loadProperties = async () => {
  loading.value = true;

  try {
    const response = await propertyService.getAll({
      ...filters.value,
      page: pagination.value.page,
    });

    properties.value = response.data;
    pagination.value.rowsNumber = response.total;
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: error.message || 'Erro ao carregar imóveis',
    });
  } finally {
    loading.value = false;
  }
};

const viewProperty = (id: string) => {
  router.push(`/admin/properties/${id}`);
};

const editProperty = (id: string) => {
  router.push(`/admin/properties/${id}/edit`);
};

const deleteProperty = (id: string) => {
  $q.dialog({
    title: 'Confirmar exclusão',
    message: 'Tem certeza que deseja deletar este imóvel?',
    cancel: true,
    persistent: true,
  }).onOk(async () => {
    try {
      await propertyService.delete(id);

      $q.notify({
        type: 'positive',
        message: 'Imóvel deletado com sucesso',
      });

      loadProperties();
    } catch (error: any) {
      $q.notify({
        type: 'negative',
        message: error.message || 'Erro ao deletar imóvel',
      });
    }
  });
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
  await loadProperties();
});
</script>
