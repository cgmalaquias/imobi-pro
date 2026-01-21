import { boot } from 'quasar/wrappers';
import type { AxiosInstance } from 'axios';
import axios from 'axios';
import { useAuthStore } from 'src/stores/auth';
import { Notify } from 'quasar';
import type { Router } from 'vue-router'; // Importar Router para tipagem

declare module '@vue/runtime-core' {
  interface ComponentCustomProperties {
    $axios: AxiosInstance;
    $api: AxiosInstance;
  }
}

const api = axios.create({ baseURL: process.env.API_URL || 'http://localhost:3000/api' });

export default boot(({ app, router }: { app: any; router: Router }) => { // Tipagem explícita para router
  app.config.globalProperties.$axios = axios;
  app.config.globalProperties.$api = api;

  api.interceptors.request.use(
    (config) => {
      const authStore = useAuthStore();
      if (authStore.token) {
        config.headers.Authorization = `Bearer ${authStore.token}`;
      }
      return config;
    },
    (error: any) => { // Usar any para erro do interceptor, pois pode ser variado
      console.error('❌ Erro no interceptor de requisição:', error);
      return Promise.reject(error);
    }
  );

  api.interceptors.response.use(
    (response) => response,
    async (error: any) => { // Usar any para erro do interceptor
      if (error.response?.status === 401 || error.response?.status === 403) {
        console.error('❌ Erro 401/403 - Token inválido ou expirado');
        const authStore = useAuthStore();
        authStore.logout();
        Notify.create({
          type: 'negative',
          message: 'Sessão expirada ou não autorizado. Faça login novamente.',
          position: 'top-right',
        });
        await router.push({ name: 'login' });
      }
      return Promise.reject(error);
    }
  );
});

export { api };
