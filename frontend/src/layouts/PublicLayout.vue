<template>
  <q-layout view="hHh lpR fFf">
    <!-- Header Público -->
    <q-header elevated class="bg-primary text-white">
      <q-toolbar>
        <q-toolbar-title>
          <div
            class="row items-center cursor-pointer"
            @click="router.push({ name: 'public-properties' })"
          >
            <q-icon name="business" size="sm" class="q-mr-sm" />
            <span>Imobiliária Pro</span>
          </div>
        </q-toolbar-title>

        <q-btn flat label="Imóveis" @click="router.push({ name: 'public-properties' })" />
        <q-btn flat label="Contato" @click="router.push({ name: 'contact' })" />
        <q-btn flat label="Admin" icon="login" @click="router.push({ name: 'login' })" />
      </q-toolbar>
    </q-header>

    <!-- Conteúdo Principal -->
    <q-page-container>
      <router-view />
    </q-page-container>

    <!-- Footer Público -->
    <q-footer elevated class="bg-grey-9 text-white">
      <q-toolbar>
        <q-toolbar-title class="text-center">
          <div class="text-caption">© 2024 Imobiliária Pro - Todos os direitos reservados</div>
        </q-toolbar-title>
      </q-toolbar>
    </q-footer>
  </q-layout>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router';

const router = useRouter();
</script>
