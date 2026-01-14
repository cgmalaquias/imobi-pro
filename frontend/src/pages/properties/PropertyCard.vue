<template>
  <q-card class="property-card cursor-pointer" @click="goToDetails">
    <div class="property-image-container">
      <q-img :src="coverImage" :ratio="16 / 9" spinner-color="primary" class="property-image">
        <template v-slot:error>
          <div class="absolute-full flex flex-center bg-grey-3">
            <q-icon name="home" size="64px" color="grey-5" />
          </div>
        </template>
      </q-img>

      <q-badge
        v-if="property.featured"
        color="amber"
        text-color="black"
        class="absolute-top-left q-ma-sm"
      >
        <q-icon name="star" size="16px" class="q-mr-xs" />
        Destaque
      </q-badge>

      <q-badge :color="getStatusColor(property.status)" class="absolute-top-right q-ma-sm">
        {{ property.status }}
      </q-badge>
    </div>

    <q-card-section>
      <div class="text-h6 text-weight-bold ellipsis-2-lines">
        {{ property.title }}
      </div>

      <div class="text-subtitle2 text-grey-7 q-mt-xs">
        <q-icon name="place" size="16px" />
        {{ property.city }}, {{ property.state }}
      </div>

      <div class="row q-mt-md q-gutter-sm">
        <div v-if="property.bedrooms > 0" class="col-auto">
          <q-chip dense size="sm" icon="bed" color="grey-3" text-color="grey-8">
            {{ property.bedrooms }}
          </q-chip>
        </div>
        <div v-if="property.bathrooms > 0" class="col-auto">
          <q-chip dense size="sm" icon="bathroom" color="grey-3" text-color="grey-8">
            {{ property.bathrooms }}
          </q-chip>
        </div>
        <div v-if="property.garage > 0" class="col-auto">
          <q-chip dense size="sm" icon="garage" color="grey-3" text-color="grey-8">
            {{ property.garage }}
          </q-chip>
        </div>
        <div class="col-auto">
          <q-chip dense size="sm" icon="square_foot" color="grey-3" text-color="grey-8">
            {{ property.area }}m²
          </q-chip>
        </div>
      </div>

      <q-separator class="q-my-md" />

      <div class="row items-center justify-between">
        <div class="col">
          <div v-if="property.price_sale" class="text-h6 text-weight-bold text-primary">
            {{ formatCurrency(property.price_sale) }}
          </div>
          <div v-if="property.price_rent" class="text-subtitle2 text-grey-7">
            Aluguel: {{ formatCurrency(property.price_rent) }}/mês
          </div>
        </div>

        <div class="col-auto">
          <q-btn flat dense round icon="more_vert" @click.stop="showMenu = true">
            <q-menu v-model="showMenu">
              <q-list style="min-width: 150px">
                <q-item clickable v-ripple @click="handleEdit">
                  <q-item-section avatar>
                    <q-icon name="edit" />
                  </q-item-section>
                  <q-item-section>Editar</q-item-section>
                </q-item>

                <q-item clickable v-ripple @click="handleDelete">
                  <q-item-section avatar>
                    <q-icon name="delete" color="negative" />
                  </q-item-section>
                  <q-item-section>Excluir</q-item-section>
                </q-item>
              </q-list>
            </q-menu>
          </q-btn>
        </div>
      </div>
    </q-card-section>
  </q-card>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import { Property, PropertyStatus } from '@types/index';

interface Props {
  property: Property;
}

interface Emits {
  (e: 'edit', property: Property): void;
  (e: 'delete', property: Property): void;
}

const props = defineProps<Props>();
const emit = defineEmits<Emits>();
const router = useRouter();

const showMenu = ref(false);

const coverImage = computed(() => {
  const cover = props.property.images?.find((img) => img.is_cover);
  return cover?.url || props.property.images?.[0]?.url || '/placeholder-property.jpg';
});

const getStatusColor = (status: PropertyStatus): string => {
  const colors: Record<PropertyStatus, string> = {
    disponivel: 'positive',
    reservado: 'warning',
    vendido: 'info',
    alugado: 'primary',
    inativo: 'grey',
  };
  return colors[status] || 'grey';
};

const formatCurrency = (value: number): string => {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL',
  }).format(value);
};

const goToDetails = () => {
  router.push(`/properties/${props.property.id}`);
};

const handleEdit = () => {
  emit('edit', props.property);
  showMenu.value = false;
};

const handleDelete = () => {
  emit('delete', props.property);
  showMenu.value = false;
};
</script>

<style scoped lang="scss">
.property-card {
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.3s ease;

  &:hover {
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
    transform: translateY(-4px);
  }
}

.property-image-container {
  position: relative;
}

.property-image {
  transition: transform 0.3s ease;
}

.property-card:hover .property-image {
  transform: scale(1.05);
}

.ellipsis-2-lines {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
