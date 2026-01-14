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

    <div v-if="clientStore.loading" class="text-center q-pa-xl">
      <q-spinner color="primary" size="50px" />
    </div>

    <div v-else-if="!currentClient" class="text-center q-pa-xl">
      <q-icon name="person" size="80px" color="grey-5" />
      <p class="text-h6 text-grey-6 q-mt-md">Cliente não encontrado</p>
    </div>

    <div v-else class="row q-col-gutter-lg">
      <!-- Informações do Cliente -->
      <div class="col-xs-12 col-md-8">
        <!-- Dados Pessoais -->
        <q-card class="q-mb-md">
          <q-card-section>
            <div class="flex items-center q-gutter-md q-mb-md">
              <q-avatar color="primary" text-color="white" size="80px">
                {{ currentClient.name.charAt(0).toUpperCase() }}
              </q-avatar>
              <div>
                <div class="text-h5 text-weight-bold">{{ currentClient.name }}</div>
                <div class="text-subtitle2 text-grey-7">{{ currentClient.email }}</div>
                <div class="text-subtitle2 text-grey-7">{{ currentClient.phone }}</div>
              </div>
            </div>

            <q-separator class="q-my-md" />

            <div class="row q-col-gutter-md">
              <div class="col-xs-12 col-md-6">
                <div class="text-subtitle2 text-weight-bold q-mb-xs">CPF</div>
                <div class="text-grey-8">{{ currentClient.cpf || 'Não informado' }}</div>
              </div>
              <div class="col-xs-12 col-md-6">
                <div class="text-subtitle2 text-weight-bold q-mb-xs">Data de Nascimento</div>
                <div class="text-grey-8">
                  {{
                    currentClient.date_birth
                      ? formatDate(currentClient.date_birth)
                      : 'Não informada'
                  }}
                </div>
              </div>
            </div>

            <q-separator class="q-my-md" />

            <div class="row q-col-gutter-md">
              <div class="col-xs-12 col-md-6">
                <div class="text-subtitle2 text-weight-bold q-mb-xs">Origem</div>
                <q-badge :color="getSourceColor(currentClient.source)">
                  {{ currentClient.source }}
                </q-badge>
              </div>
              <div class="col-xs-12 col-md-6">
                <div class="text-subtitle2 text-weight-bold q-mb-xs">Status</div>
                <q-badge :color="currentClient.active ? 'positive' : 'negative'">
                  {{ currentClient.active ? 'Ativo' : 'Inativo' }}
                </q-badge>
              </div>
            </div>
          </q-card-section>
        </q-card>

        <!-- Endereço -->
        <q-card v-if="currentClient.address" class="q-mb-md">
          <q-card-section>
            <div class="text-h6 text-weight-bold q-mb-md">Endereço</div>
            <p class="text-grey-8 q-ma-none">
              {{ currentClient.address }}<br />
              {{ currentClient.neighborhood }}<br />
              {{ currentClient.city }}, {{ currentClient.state }}
              <span v-if="currentClient.zip_code"> - CEP: {{ currentClient.zip_code }}</span>
            </p>
          </q-card-section>
        </q-card>

        <!-- Observações -->
        <q-card v-if="currentClient.notes" class="q-mb-md">
          <q-card-section>
            <div class="text-h6 text-weight-bold q-mb-md">Observações</div>
            <p class="text-grey-8 q-ma-none" style="white-space: pre-line">
              {{ currentClient.notes }}
            </p>
          </q-card-section>
        </q-card>

        <!-- Leads Associados -->
        <q-card>
          <q-card-section>
            <div class="flex justify-between items-center q-mb-md">
              <div class="text-h6 text-weight-bold">Leads Associados</div>
              <q-btn
                flat
                dense
                label="Novo Lead"
                icon="add"
                color="primary"
                @click="showLeadDialog = true"
              />
            </div>
          </q-card-section>

          <q-separator />

          <q-list v-if="currentClient.leads && currentClient.leads.length > 0" separator>
            <q-item
              v-for="lead in currentClient.leads"
              :key="lead.id"
              clickable
              @click="$router.push(`/leads/${lead.id}`)"
            >
              <q-item-section avatar>
                <q-avatar color="orange" text-color="white" icon="trending_up" />
              </q-item-section>
              <q-item-section>
                <q-item-label>{{ lead.property?.title }}</q-item-label>
                <q-item-label caption
                  >{{ lead.property?.city }}, {{ lead.property?.state }}</q-item-label
                >
              </q-item-section>
              <q-item-section side>
                <q-badge :color="getLeadStatusColor(lead.status)">
                  {{ lead.status }}
                </q-badge>
              </q-item-section>
            </q-item>
          </q-list>

          <q-card-section v-else class="text-center text-grey-6">
            <q-icon name="trending_up" size="48px" color="grey-5" />
            <p class="q-mt-md">Nenhum lead cadastrado</p>
          </q-card-section>
        </q-card>
      </div>

      <!-- Sidebar - Ações -->
      <div class="col-xs-12 col-md-4">
        <!-- Ações Rápidas -->
        <q-card class="q-mb-md">
          <q-card-section class="q-gutter-md">
            <q-btn
              color="primary"
              label="Enviar Email"
              icon="email"
              class="full-width"
              @click="handleSendEmail"
            />
            <q-btn
              flat
              color="primary"
              label="Enviar WhatsApp"
              icon="chat"
              class="full-width"
              @click="handleSendWhatsApp"
            />
            <q-btn
              flat
              color="primary"
              label="Ligar"
              icon="phone"
              class="full-width"
              @click="handleCall"
            />
          </q-card-section>
        </q-card>

        <!-- Informações Adicionais -->
        <q-card class="q-mb-md">
          <q-card-section>
            <div class="text-subtitle2 text-weight-bold q-mb-md">Informações</div>
            <div class="q-gutter-md">
              <div>
                <div class="text-caption text-grey-7">Total de Leads</div>
                <div class="text-h5 text-weight-bold">
                  {{ currentClient.leads?.length || 0 }}
                </div>
              </div>
              <div>
                <div class="text-caption text-grey-7">Leads Concluídos</div>
                <div class="text-h5 text-weight-bold text-positive">
                  {{ currentClient.leads?.filter((l) => l.status === 'concluido').length || 0 }}
                </div>
              </div>
              <div>
                <div class="text-caption text-grey-7">Data de Cadastro</div>
                <div class="text-grey-8">{{ formatDate(currentClient.createdAt) }}</div>
              </div>
            </div>
          </q-card-section>
        </q-card>

        <!-- Histórico de Atividades -->
        <q-card>
          <q-card-section>
            <div class="text-subtitle2 text-weight-bold q-mb-md">Últimas Atividades</div>
            <q-timeline layout="dense" color="primary">
              <q-timeline-entry
                v-for="(lead, index) in recentLeads"
                :key="lead.id"
                :title="lead.property?.title"
                :subtitle="`${lead.status} - ${formatDate(lead.createdAt)}`"
                icon="trending_up"
              />
              <q-timeline-entry
                v-if="recentLeads.length === 0"
                title="Sem atividades"
                subtitle="Nenhuma atividade registrada"
                icon="info"
              />
            </q-timeline>
          </q-card-section>
        </q-card>
      </div>
    </div>

    <!-- Dialog Editar Cliente -->
    <q-dialog v-model="showEditDialog" persistent>
      <q-card style="min-width: 500px">
        <q-card-section class="row items-center q-pb-none">
          <div class="text-h6">Editar Cliente</div>
          <q-space />
          <q-btn icon="close" flat round dense @click="showEditDialog = false" />
        </q-card-section>

        <q-card-section>
          <q-form @submit="handleUpdate" class="q-gutter-md">
            <q-input
              v-model="editForm.name"
              label="Nome Completo *"
              outlined
              dense
              :rules="[(val) => !!val || 'Nome é obrigatório']"
            />

            <div class="row q-col-gutter-md">
              <div class="col-xs-12 col-md-6">
                <q-input
                  v-model="editForm.email"
                  type="email"
                  label="Email *"
                  outlined
                  dense
                  :rules="[(val) => !!val || 'Email é obrigatório']"
                />
              </div>
              <div class="col-xs-12 col-md-6">
                <q-input
                  v-model="editForm.phone"
                  label="Telefone *"
                  outlined
                  dense
                  mask="(##) #####-####"
                  :rules="[(val) => !!val || 'Telefone é obrigatório']"
                />
              </div>
            </div>

            <div class="row q-col-gutter-md">
              <div class="col-xs-12 col-md-6">
                <q-input v-model="editForm.cpf" label="CPF" outlined dense mask="###.###.###-##" />
              </div>
              <div class="col-xs-12 col-md-6">
                <q-input
                  v-model="editForm.date_birth"
                  label="Data de Nascimento"
                  outlined
                  dense
                  type="date"
                />
              </div>
            </div>

            <q-input v-model="editForm.address" label="Endereço" outlined dense />

            <div class="row q-col-gutter-md">
              <div class="col-xs-12 col-md-4">
                <q-input v-model="editForm.neighborhood" label="Bairro" outlined dense />
              </div>
              <div class="col-xs-12 col-md-4">
                <q-input v-model="editForm.city" label="Cidade" outlined dense />
              </div>
              <div class="col-xs-12 col-md-4">
                <q-input v-model="editForm.state" label="Estado" outlined dense maxlength="2" />
              </div>
            </div>

            <q-select
              v-model="editForm.source"
              label="Origem"
              outlined
              dense
              :options="sourceOptions"
              emit-value
              map-options
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
              <q-btn
                type="submit"
                color="primary"
                label="Atualizar"
                :loading="clientStore.loading"
              />
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </q-dialog>

    <!-- Dialog Criar Lead -->
    <q-dialog v-model="showLeadDialog" persistent>
      <q-card style="min-width: 500px">
        <q-card-section class="row items-center q-pb-none">
          <div class="text-h6">Criar Lead para este Cliente</div>
          <q-space />
          <q-btn icon="close" flat round dense @click="showLeadDialog = false" />
        </q-card-section>

        <q-card-section>
          <q-form @submit="handleCreateLead" class="q-gutter-md">
            <q-select
              v-model="leadForm.property_id"
              label="Imóvel *"
              outlined
              dense
              :options="propertyOptions"
              option-value="id"
              option-label="title"
              :rules="[(val) => !!val || 'Imóvel é obrigatório']"
            />

            <q-input
              v-model="leadForm.notes"
              label="Observações"
              outlined
              type="textarea"
              rows="3"
            />

            <div class="row justify-end q-gutter-md">
              <q-btn flat label="Cancelar" @click="showLeadDialog = false" />
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
  </q-page>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue';
import { useRoute } from 'vue-router';
import { useClientStore } from '@stores/client';
import { useLeadStore } from '@stores/lead';
import { usePropertyStore } from '@stores/property';
import { useQuasar } from 'quasar';
import { Client, Lead, LeadStatus } from '@types/index';

const route = useRoute();
const clientStore = useClientStore();
const leadStore = useLeadStore();
const propertyStore = usePropertyStore();
const $q = useQuasar();

const showEditDialog = ref(false);
const showLeadDialog = ref(false);

const editForm = reactive({
  name: '',
  email: '',
  phone: '',
  cpf: '',
  date_birth: '',
  address: '',
  neighborhood: '',
  city: '',
  state: '',
  zip_code: '',
  source: 'site',
  notes: '',
});

const leadForm = reactive({
  property_id: '',
  notes: '',
});

const sourceOptions = [
  { label: 'Site', value: 'site' },
  { label: 'Indicação', value: 'indicacao' },
  { label: 'Anúncio', value: 'anuncio' },
  { label: 'Outro', value: 'outro' },
];

const currentClient = computed(() => clientStore.currentClient);

const propertyOptions = computed(() => propertyStore.properties);

const recentLeads = computed(() => {
  return currentClient.value?.leads?.slice(0, 3) || [];
});

const getSourceColor = (source: string): string => {
  const colors: Record<string, string> = {
    site: 'blue',
    indicacao: 'green',
    anuncio: 'orange',
    outro: 'grey',
  };
  return colors[source] || 'grey';
};

const getLeadStatusColor = (status: LeadStatus): string => {
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

const formatDate = (date: string | undefined): string => {
  if (!date) return 'N/A';
  return new Date(date).toLocaleDateString('pt-BR');
};

const handleSendEmail = () => {
  if (currentClient.value?.email) {
    window.location.href = `mailto:${currentClient.value.email}`;
  }
};

const handleSendWhatsApp = () => {
  if (currentClient.value?.phone) {
    const phone = currentClient.value.phone.replace(/\D/g, '');
    window.open(`https://wa.me/55${phone}`, '_blank');
  }
};

const handleCall = () => {
  if (currentClient.value?.phone) {
    window.location.href = `tel:${currentClient.value.phone}`;
  }
};

const handleUpdate = async () => {
  if (currentClient.value) {
    await clientStore.update(currentClient.value.id, editForm);
    showEditDialog.value = false;
    await clientStore.fetchById(currentClient.value.id);
  }
};

const handleCreateLead = async () => {
  if (currentClient.value) {
    const lead = await leadStore.create({
      client_id: currentClient.value.id,
      property_id: leadForm.property_id,
      status: 'novo',
      stage: 'prospeccao',
      notes: leadForm.notes,
      probability: 10,
    });

    if (lead) {
      showLeadDialog.value = false;
      leadForm.property_id = '';
      leadForm.notes = '';
      await clientStore.fetchById(currentClient.value.id);
    }
  }
};

const loadClient = async () => {
  const clientId = route.params.id as string;
  await clientStore.fetchById(clientId);

  if (currentClient.value) {
    Object.assign(editForm, currentClient.value);
  }

  // Carregar imóveis para o select
  await propertyStore.fetchAll();
};

onMounted(() => {
  loadClient();
});
</script>

<style scoped lang="scss">
.q-timeline {
  padding: 0;
}
</style>
