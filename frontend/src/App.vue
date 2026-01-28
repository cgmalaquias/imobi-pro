<template>
  <router-view />
</template>

<style>
/* Debug: remover qualquer overlay invisível */
.q-loading-bar {
  display: none !important;
}

.q-inner-loading {
  z-index: 1000 !important;
}
</style>
