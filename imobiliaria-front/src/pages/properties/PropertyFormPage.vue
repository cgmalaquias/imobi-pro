<template>
  <q-page class="q-pa-md">
    <div class="text-h4 q-mb-md">
      {{ isEdit ? 'Editar Imóvel' : 'Novo Imóvel' }}
    </div>

    <q-form @submit="handleSubmit" class="row q-col-gutter-md">
      <!-- Coluna esquerda -->
      <div class="col-12 col-md-8">
        <!-- Informações básicas -->
        <q-card class="q-mb-md">
          <q-card-section>
            <div class="text-h6 q-mb-md">Informações Básicas</div>

            <q-input
              v-model="form.title"
              label="Título"
              outlined
              dense
              :rules="[(val) => !!val || 'Título obrigatório']"
              class="q-mb-md"
            />

            <q-input
              v-model="form.description"
              label="Descrição"
              type="textarea"
              outlined
              rows="5"
              :rules="[(val) => !!val || 'Descrição obrigatória']"
              class="q-mb-md"
            />

            <div class="row q-col-gutter-md q-mb-md">
              <div class="col-12 col-md-6">
                <q-select
                  v-model="form.type"
                  :options="propertyTypes"
                  label="Tipo"
                  outlined
                  dense
                  :rules="[(val) => !!val || 'Tipo obrigatório']"
                />
              </div>

              <div class="col-12 col-md-6">
                <q-select
                  v-model="form.status"
                  :options="propertyStatuses"
                  label="Status"
                  outlined
                  dense
                  :rules="[(val) => !!val || 'Status obrigatório']"
                />
              </div>
            </div>
          </q-card-section>
        </q-card>

        <!-- Detalhes do imóvel -->
        <q-card class="q-mb-md">
          <q-card-section>
            <div class="text-h6 q-mb-md">Detalhes</div>

            <div class="row q-col-gutter-md q-mb-md">
              <div class="col-12 col-md-6">
                <q-input
                  v-model.number="form.price"
                  label="Preço"
                  type="number"
                  outlined
                  dense
                  prefix="R$"
                  :rules="[(val) => val > 0 || 'Preço obrigatório']"
                />
              </div>

              <div class="col-12 col-md-6">
                <q-input
                  v-model.number="form.area"
                  label="Área (m²)"
                  type="number"
                  outlined
                  dense
                />
              </div>
            </div>

            <div class="row q-col-gutter-md">
              <div class="col-12 col-md-4">
                <q-input
                  v-model.number="form.bedrooms"
                  label="Quartos"
                  type="number"
                  outlined
                  dense
                />
              </div>

              <div class="col-12 col-md-4">
                <q-input
                  v-model.number="form.bathrooms"
                  label="Banheiros"
                  type="number"
                  outlined
                  dense
                />
              </div>

              <div class="col-12 col-md-4">
                <q-input
                  v-model.number="form.garages"
                  label="Vagas de garagem"
                  type="number"
                  outlined
                  dense
                />
              </div>
            </div>
          </q-card-section>
        </q-card>

        <!-- Localização -->
        <q-card class="q-mb-md">
          <q-card-section>
            <div class="text-h6 q-mb-md">Localização</div>

            <q-input
              v-model="form.address"
              label="Endereço"
              outlined
              dense
              :rules="[(val) => !!val || 'Endereço obrigatório']"
              class="q-mb-md"
            />

            <div class="row q-col-gutter-md q-mb-md">
              <div class="col-12 col-md-6">
                <q-input
                  v-model="form.city"
                  label="Cidade"
                  outlined
                  dense
                  :rules="[(val) => !!val || 'Cidade obrigatória']"
                />
              </div>

              <div class="col-12 col-md-3">
                <q-input
                  v-model="form.state"
                  label="Estado"
                  outlined
                  dense
                  maxlength="2"
                  :rules="[(val) => !!val || 'Estado obrigatório']"
                />
              </div>

              <div class="col-12 col-md-3">
                <q-input v-model="form.zip_code" label="CEP" mask="#####-###" outlined dense />
              </div>
            </div>

            <div class="row q-col-gutter-md">
              <div class="col-12 col-md-6">
                <q-input
                  v-model.number="form.latitude"
                  label="Latitude"
                  type="number"
                  outlined
                  dense
                />
              </div>

              <div class="col-12 col-md-6">
                <q-input
                  v-model.number="form.longitude"
                  label="Longitude"
                  type="number"
                  outlined
                  dense
                />
              </div>
            </div>
          </q-card-section>
        </q-card>

        <!-- Características -->
        <q-card class="q-mb-md">
          <q-card-section>
            <div class="text-h6 q-mb-md">Características</div>

            <div class="row q-col-gutter-md q-mb-md">
              <div class="col-12">
                <q-input
                  v-model="newFeature"
                  label="Adicionar característica"
                  outlined
                  dense
                  @keyup.enter="addFeature"
                >
                  <template v-slot:append>
                    <q-btn flat dense round icon="add" @click="addFeature" />
                  </template>
                </q-input>
              </div>
            </div>

            <div v-if="form.features.length > 0" class="row q-col-gutter-sm">
              <q-chip
                v-for="(feature, index) in form.features"
                :key="index"
                removable
                @remove="form.features.splice(index, 1)"
              >
                {{ feature }}
              </q-chip>
            </div>
          </q-card-section>
        </q-card>
      </div>

      <!-- Coluna direita -->
      <div class="col-12 col-md-4">
        <!-- Imagens -->
        <q-card class="q-mb-md">
          <q-card-section>
            <div class="text-h6 q-mb-md">Imagens</div>

            <q-file
              v-model="imageFiles"
              label="Selecionar imagens"
              outlined
              dense
              multiple
              accept="image/*"
              max-file-size="5242880"
              @rejected="onFileRejected"
              class="q-mb-md"
            />

            <div v-if="form.images.length > 0" class="row q-col-gutter-sm">
              <div v-for="(image, index) in form.images" :key="index" class="col-6">
                <div class="relative-position">
                  <q-img :src="image.url" ratio="1" class="rounded-borders" />
                  <q-btn
                    flat
                    dense
                    round
                    icon="delete"
                    color="negative"
                    size="sm"
                    class="absolute-top-right"
                    @click="removeImage(index)"
                  />
                </div>
              </div>
            </div>

            <div v-if="imageFiles.length > 0" class="text-caption text-grey-7 q-mt-md">
              {{ imageFiles.length }} imagem(ns) selecionada(s)
            </div>
          </q-card-section>
        </q-card>

        <!-- Ações -->
        <q-card>
          <q-card-section>
            <div class="row q-col-gutter-sm">
              <q-btn
                type="submit"
                label="Salvar"
                color="primary"
                class="full-width"
                :loading="submitting"
              />

              <q-btn label="Cancelar" color="grey-7" class="full-width" to="/admin/properties" />
            </div>
          </q-card-section>
        </q-card>
      </div>
    </q-form>

    <!-- Loading -->
    <q-inner-loading :showing="loading">
      <q-spinner-gears size="50px" color="primary" />
    </q-inner-loading>
  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useQuasar } from 'quasar';
import type { PropertyImage } from 'src/services/property.service';
import { propertyService, Property } from 'src/services/property.service';

const router = useRouter();
const route = useRoute();
const $q = useQuasar();

const isEdit = ref(false);
const loading = ref(false);
const submitting = ref(false);
const imageFiles = ref<File[]>([]);
const newFeature = ref('');

const form = ref({
  title: '',
  description: '',
  type: null as string | null,
  status: 'DISPONIVEL' as string,
  price: 0,
  area: null as number | null,
  bedrooms: null as number | null,
  bathrooms: null as number | null,
  garages: null as number | null,
  address: '',
  city: '',
  state: '',
  zip_code: '',
  latitude: null as number | null,
  longitude: null as number | null,
  images: [] as PropertyImage[],
  features: [] as string[],
});

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

const loadProperty = async () => {
  const id = route.params.id as string;

  if (!id) return;

  isEdit.value = true;
  loading.value = true;

  try {
    const property = await propertyService.getById(id);

    form.value = {
      title: property.title,
      description: property.description,
      type: property.type,
      status: property.status,
      price: property.price,
      area: property.area || null,
      bedrooms: property.bedrooms || null,
      bathrooms: property.bathrooms || null,
      garages: property.garages || null,
      address: property.address,
      city: property.city,
      state: property.state,
      zip_code: property.zip_code || '',
      latitude: property.latitude || null,
      longitude: property.longitude || null,
      images: property.images || [],
      features: property.features?.map((f) => f.name) || [],
    };
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: error.message || 'Erro ao carregar imóvel',
    });

    router.push('/admin/properties');
  } finally {
    loading.value = false;
  }
};

const addFeature = () => {
  if (newFeature.value.trim()) {
    form.value.features.push(newFeature.value.trim());
    newFeature.value = '';
  }
};

const removeImage = (index: number) => {
  form.value.images.splice(index, 1);
};

const onFileRejected = (rejectedEntries: any[]) => {
  $q.notify({
    type: 'negative',
    message: 'Arquivo muito grande (máximo 5MB)',
  });
};

const handleSubmit = async () => {
  if (!form.value.type) {
    $q.notify({
      type: 'negative',
      message: 'Selecione um tipo de imóvel',
    });
    return;
  }

  submitting.value = true;

  try {
    const formData = new FormData();

    // Adicionar campos básicos
    formData.append('title', form.value.title);
    formData.append('description', form.value.description);
    formData.append('type', form.value.type);
    formData.append('status', form.value.status);
    formData.append('price', String(form.value.price));
    formData.append('address', form.value.address);
    formData.append('city', form.value.city);
    formData.append('state', form.value.state);

    // Campos opcionais
    if (form.value.area) formData.append('area', String(form.value.area));
    if (form.value.bedrooms) formData.append('bedrooms', String(form.value.bedrooms));
    if (form.value.bathrooms) formData.append('bathrooms', String(form.value.bathrooms));
    if (form.value.garages) formData.append('garages', String(form.value.garages));
    if (form.value.zip_code) formData.append('zip_code', form.value.zip_code);
    if (form.value.latitude) formData.append('latitude', String(form.value.latitude));
    if (form.value.longitude) formData.append('longitude', String(form.value.longitude));

    // Adicionar imagens novas
    imageFiles.value.forEach((file, index) => {
      formData.append(`images[${index}]`, file);
    });

    // Adicionar características
    form.value.features.forEach((feature, index) => {
      formData.append(`features[${index}]`, feature);
    });

    let response;

    if (isEdit.value) {
      response = await propertyService.update(route.params.id as string, formData);
    } else {
      response = await propertyService.create(formData);
    }

    $q.notify({
      type: 'positive',
      message: isEdit.value ? 'Imóvel atualizado com sucesso' : 'Imóvel criado com sucesso',
    });

    router.push('/admin/properties');
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: error.message || 'Erro ao salvar imóvel',
    });
  } finally {
    submitting.value = false;
  }
};

onMounted(async () => {
  if (route.params.id) {
    await loadProperty();
  }
});
</script>
