<template>
  <q-page class="flex flex-center">
    <div>
      <h1>Teste de Clique</h1>
      <q-btn label="Clique aqui" color="primary" @click="handleClick" />
    </div>
  </q-page>
</template>

<script setup lang="ts">
const handleClick = () => {
  alert('Funcionou!');
};
</script>
