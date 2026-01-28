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

/* Garantir que nada está bloqueando */
* {
  pointer-events: auto !important;
}
</style>
