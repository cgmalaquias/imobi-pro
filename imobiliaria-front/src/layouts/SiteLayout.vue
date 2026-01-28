<!-- FILE: frontend/src/layouts/SiteLayout.vue -->
<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated class="bg-primary text-white">
      <q-toolbar>
        <q-toolbar-title>
          <router-link to="/" class="text-white" style="text-decoration: none">
            ImobiPro
          </router-link>
        </q-toolbar-title>

        <q-btn flat label="Início" to="/" />
        <q-btn flat label="Imóveis" to="/imoveis" />
        <q-btn flat label="Contato" to="/contato" />
        <q-btn flat label="Login" to="/auth/login" />
      </q-toolbar>
    </q-header>

    <q-page-container>
      <router-view />
    </q-page-container>

    <q-footer elevated class="bg-grey-8 text-white">
      <q-toolbar>
        <q-toolbar-title>
          <div class="text-caption">
            © {{ new Date().getFullYear() }} ImobiPro. Todos os direitos reservados.
          </div>
        </q-toolbar-title>
      </q-toolbar>
    </q-footer>
  </q-layout>
</template>

<script setup lang="ts">
// Layout para o site público
</script>
