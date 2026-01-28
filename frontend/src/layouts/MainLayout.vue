<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated>
      <q-toolbar>
        <q-btn flat dense round icon="menu" aria-label="Menu" @click="toggleLeftDrawer" />

        <q-toolbar-title> Imobiliária - Admin </q-toolbar-title>

        <div>{{ user?.name }}</div>

        <q-btn flat dense round icon="logout" @click="handleLogout">
          <q-tooltip>Sair</q-tooltip>
        </q-btn>
      </q-toolbar>
    </q-header>

    <q-drawer v-model="leftDrawerOpen" show-if-above bordered>
      <q-list>
        <q-item-label header> Menu </q-item-label>

        <q-item clickable to="/admin" exact>
          <q-item-section avatar>
            <q-icon name="dashboard" />
          </q-item-section>
          <q-item-section>
            <q-item-label>Dashboard</q-item-label>
          </q-item-section>
        </q-item>

        <q-item clickable to="/admin/properties">
          <q-item-section avatar>
            <q-icon name="home_work" />
          </q-item-section>
          <q-item-section>
            <q-item-label>Imóveis</q-item-label>
          </q-item-section>
        </q-item>

        <q-item clickable to="/admin/leads">
          <q-item-section avatar>
            <q-icon name="event" />
          </q-item-section>
          <q-item-section>
            <q-item-label>Visitas</q-item-label>
          </q-item-section>
        </q-item>

        <q-item clickable to="/admin/users" v-if="isAdmin">
          <q-item-section avatar>
            <q-icon name="people" />
          </q-item-section>
          <q-item-section>
            <q-item-label>Usuários</q-item-label>
          </q-item-section>
        </q-item>

        <q-separator />

        <q-item clickable to="/admin/profile">
          <q-item-section avatar>
            <q-icon name="person" />
          </q-item-section>
          <q-item-section>
            <q-item-label>Perfil</q-item-label>
          </q-item-section>
        </q-item>
      </q-list>
    </q-drawer>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import { authService } from 'src/services/auth.service';

const router = useRouter();
const $q = useQuasar();

const leftDrawerOpen = ref(false);
const user = computed(() => authService.getUser());
const isAdmin = computed(() => authService.isAdmin());

const toggleLeftDrawer = () => {
  leftDrawerOpen.value = !leftDrawerOpen.value;
};

const handleLogout = async () => {
  $q.dialog({
    title: 'Confirmar',
    message: 'Deseja realmente sair?',
    cancel: true,
    persistent: true,
  }).onOk(async () => {
    try {
      await authService.logout();

      $q.notify({
        type: 'positive',
        message: 'Logout realizado com sucesso',
        position: 'top',
      });

      router.push('/auth/login');
    } catch (error: any) {
      $q.notify({
        type: 'negative',
        message: error.message || 'Erro ao fazer logout',
        position: 'top',
      });
    }
  });
};
</script>
