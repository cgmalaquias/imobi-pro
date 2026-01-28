<template>
  <q-page class="flex flex-center bg-grey-2">
    <q-card style="width: 400px; max-width: 90vw">
      <q-card-section class="bg-primary text-white text-center">
        <div class="text-h5">Imobiliária</div>
        <div class="text-subtitle2">Sistema de Gestão</div>
      </q-card-section>

      <q-card-section>
        <q-form @submit="handleLogin">
          <q-input
            v-model="email"
            label="E-mail"
            type="email"
            outlined
            dense
            :rules="[(val) => !!val || 'E-mail obrigatório']"
            class="q-mb-md"
            autofocus
          >
            <template v-slot:prepend>
              <q-icon name="email" />
            </template>
          </q-input>

          <q-input
            v-model="password"
            label="Senha"
            :type="showPassword ? 'text' : 'password'"
            outlined
            dense
            :rules="[(val) => !!val || 'Senha obrigatória']"
            class="q-mb-md"
          >
            <template v-slot:prepend>
              <q-icon name="lock" />
            </template>
            <template v-slot:append>
              <q-icon
                :name="showPassword ? 'visibility' : 'visibility_off'"
                class="cursor-pointer"
                @click="showPassword = !showPassword"
              />
            </template>
          </q-input>

          <q-btn
            type="submit"
            label="Entrar"
            color="primary"
            class="full-width q-mb-md"
            :loading="loading"
            size="md"
          />

          <div class="text-center">
            <q-btn label="Criar conta" color="grey-7" flat to="/auth/register" size="sm" />
          </div>
        </q-form>
      </q-card-section>

      <q-separator />

      <q-card-section class="text-center text-caption text-grey-7">
        <div>Credenciais padrão:</div>
        <div>Admin: admin@imobiliaria.com / admin123</div>
        <div>Usuário: usuario@imobiliaria.com / usuario123</div>
      </q-card-section>
    </q-card>

    <!-- REMOVER q-inner-loading se não for necessário -->
  </q-page>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import { authService } from 'src/services/auth.service';

const router = useRouter();
const $q = useQuasar();

const email = ref('admin@imobiliaria.com');
const password = ref('admin123');
const showPassword = ref(false);
const loading = ref(false);

const handleLogin = async () => {
  loading.value = true;

  try {
    const response = await authService.login({
      email: email.value,
      password: password.value,
    });

    $q.notify({
      type: 'positive',
      message: `Bem-vindo, ${response.user.name}!`,
      position: 'top',
    });

    // Sempre redirecionar para admin
    router.push('/admin');
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: error.message || 'Erro ao fazer login. Verifique suas credenciais.',
      position: 'top',
    });
  } finally {
    loading.value = false;
  }
};
</script>

<style scoped>
.q-page {
  min-height: 100vh;
}
</style>
