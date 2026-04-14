<template>
  <router-view />
</template>
<script setup lang="ts">
import { useMeta } from 'quasar';

useMeta({
  titleTemplate: (title) => `${title} | Karina Carvalho Imóveis`,
  meta: {
    charset: {
      charset: 'utf-8',
    },
    viewport: {
      name: 'viewport',
      content: 'width=device-width, initial-scale=1',
    },
    ogSiteName: {
      property: 'og:site_name',
      content: 'Karina Carvalho Imóveis',
    },
  },
});
</script>
<style>
/* Debug: remover qualquer overlay invisível */
.q-loading-bar {
  display: none !important;
}

.q-inner-loading {
  z-index: 1000 !important;
}
</style>
