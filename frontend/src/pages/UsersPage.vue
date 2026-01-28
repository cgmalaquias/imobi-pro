<template>
  <q-page class="q-pa-md">
    <div class="row items-center q-mb-md">
      <div class="col">
        <div class="text-h4">Usuários</div>
      </div>
      <div class="col-auto">
        <q-btn label="Novo Usuário" color="primary" icon="add" @click="showCreateDialog = true" />
      </div>
    </div>

    <!-- Tabela de usuários -->
    <q-card>
      <q-table :rows="users" :columns="columns" row-key="id" :loading="loading" flat bordered>
        <template v-slot:body-cell-role="props">
          <q-td :props="props">
            <q-badge
              :label="getRoleLabel(props.row.role)"
              :color="props.row.role === 'ADMIN' ? 'negative' : 'primary'"
            />
          </q-td>
        </template>

        <template v-slot:body-cell-active="props">
          <q-td :props="props">
            <q-badge
              :label="props.row.active ? 'Ativo' : 'Inativo'"
              :color="props.row.active ? 'positive' : 'negative'"
            />
          </q-td>
        </template>

        <template v-slot:body-cell-actions="props">
          <q-td :props="props">
            <q-btn
              flat
              dense
              round
              icon="edit"
              color="warning"
              size="sm"
              @click="editUser(props.row)"
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
              @click="deleteUser(props.row.id)"
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

    <!-- Dialog de criar/editar usuário -->
    <q-dialog v-model="showCreateDialog">
      <q-card style="min-width: 500px">
        <q-card-section>
          <div class="text-h6">
            {{ editingUser ? 'Editar Usuário' : 'Novo Usuário' }}
          </div>
        </q-card-section>

        <q-card-section>
          <q-form @submit="handleSubmit">
            <q-input
              v-model="form.name"
              label="Nome"
              outlined
              dense
              :rules="[(val) => !!val || 'Nome obrigatório']"
              class="q-mb-md"
            />

            <q-input
              v-model="form.email"
              label="E-mail"
              type="email"
              outlined
              dense
              :rules="[(val) => !!val || 'E-mail obrigatório']"
              class="q-mb-md"
            />

            <q-input
              v-model="form.password"
              label="Senha"
              type="password"
              outlined
              dense
              :rules="[
                (val) => !editingUser || val || 'Deixe em branco para manter a senha',
                (val) => !val || val.length >= 8 || 'Mínimo 8 caracteres',
              ]"
              class="q-mb-md"
            />

            <q-select
              v-model="form.role"
              :options="roles"
              label="Função"
              outlined
              dense
              :rules="[(val) => !!val || 'Função obrigatória']"
              class="q-mb-md"
            />

            <q-checkbox v-model="form.active" label="Ativo" class="q-mb-md" />

            <div class="row q-gutter-sm">
              <q-btn type="submit" label="Salvar" color="primary" :loading="submitting" />
              <q-btn label="Cancelar" color="grey-7" flat v-close-popup />
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useQuasar } from 'quasar';
import type { User } from 'src/services/user.service';
import { userService } from 'src/services/user.service';

const $q = useQuasar();

const users = ref<User[]>([]);
const loading = ref(false);
const submitting = ref(false);
const showCreateDialog = ref(false);
const editingUser = ref<User | null>(null);

const form = ref({
  name: '',
  email: '',
  password: '',
  role: null as string | null,
  active: true,
});

const columns = [
  {
    name: 'name',
    label: 'Nome',
    field: 'name',
    align: 'left',
  },
  {
    name: 'email',
    label: 'E-mail',
    field: 'email',
    align: 'left',
  },
  {
    name: 'role',
    label: 'Função',
    field: 'role',
    align: 'left',
  },
  {
    name: 'active',
    label: 'Status',
    field: 'active',
    align: 'left',
  },
  {
    name: 'actions',
    label: 'Ações',
    field: 'actions',
    align: 'center',
  },
];

const roles = [
  { label: 'Administrador', value: 'ADMIN' },
  { label: 'Usuário', value: 'USUARIO' },
];

const loadUsers = async () => {
  loading.value = true;

  try {
    const response = await userService.getAll();
    users.value = response.data;
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: error.message || 'Erro ao carregar usuários',
    });
  } finally {
    loading.value = false;
  }
};

const editUser = (user: User) => {
  editingUser.value = user;
  form.value = {
    name: user.name,
    email: user.email,
    password: '',
    role: user.role,
    active: user.active,
  };
  showCreateDialog.value = true;
};

const deleteUser = (id: string) => {
  $q.dialog({
    title: 'Confirmar exclusão',
    message: 'Tem certeza que deseja deletar este usuário?',
    cancel: true,
    persistent: true,
  }).onOk(async () => {
    try {
      await userService.delete(id);

      $q.notify({
        type: 'positive',
        message: 'Usuário deletado com sucesso',
      });

      loadUsers();
    } catch (error: any) {
      $q.notify({
        type: 'negative',
        message: error.message || 'Erro ao deletar usuário',
      });
    }
  });
};

const handleSubmit = async () => {
  submitting.value = true;

  try {
    if (editingUser.value) {
      await userService.update(editingUser.value.id, form.value);

      $q.notify({
        type: 'positive',
        message: 'Usuário atualizado com sucesso',
      });
    } else {
      await userService.create(form.value as any);

      $q.notify({
        type: 'positive',
        message: 'Usuário criado com sucesso',
      });
    }

    showCreateDialog.value = false;
    editingUser.value = null;
    form.value = {
      name: '',
      email: '',
      password: '',
      role: null,
      active: true,
    };

    loadUsers();
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: error.message || 'Erro ao salvar usuário',
    });
  } finally {
    submitting.value = false;
  }
};

const getRoleLabel = (role: string) => {
  const labels: Record<string, string> = {
    ADMIN: 'Administrador',
    USUARIO: 'Usuário',
  };
  return labels[role] || role;
};

onMounted(async () => {
  await loadUsers();
});
</script>
