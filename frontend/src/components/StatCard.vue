<template>
  <q-card class="stat-card">
    <q-card-section>
      <div class="flex items-center justify-between">
        <div>
          <div class="text-grey-7 text-caption">{{ title }}</div>
          <div v-if="loading" class="q-mt-sm">
            <q-skeleton type="text" width="80px" height="32px" />
          </div>
          <div v-else class="text-h4 text-weight-bold q-mt-sm">
            {{ value }}
          </div>
        </div>
        <q-avatar :color="color" text-color="white" size="56px">
          <q-icon :name="icon" size="32px" />
        </q-avatar>
      </div>
    </q-card-section>
  </q-card>
</template>

<script setup lang="ts">
interface Props {
  title: string;
  value: string | number;
  icon: string;
  color: string;
  loading?: boolean;
}

defineProps<Props>();
</script>

<style scoped lang="scss">
.stat-card {
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;

  &:hover {
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    transform: translateY(-2px);
  }
}
</style>
