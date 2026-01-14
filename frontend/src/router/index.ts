// frontend/src/router/index.ts
import { createRouter, createWebHistory } from 'vue-router';
import routes from './routes';
import { useAuthStore } from 'src/stores/auth'; // Importar o authStore

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// --- MIDDLEWARE DE AUTENTICAÇÃO E AUTORIZAÇÃO ---
router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore();

  // Tenta carregar o usuário se o token existir mas o user não estiver no store (ex: refresh da página)
  if (authStore.token && !authStore.user) {
    await authStore.getMe(); // Isso vai popular authStore.user e authStore.isAdmin
  }

  // Verifica se a rota requer autenticação
  if (to.meta.requiresAuth) {
    if (!authStore.token) {
      // Se não autenticado, redireciona para a página de login
      next({ name: 'login' });
      return;
    }

    // Verifica se a rota requer privilégios de administrador
    if (to.meta.requiresAdmin && !authStore.isAdmin) {
      // Se não for admin, redireciona para o dashboard ou uma página de acesso negado
      next({ name: 'dashboard' }); // Ou uma página de erro 403
      return;
    }
  }

  // Se a rota for de login/registro e o usuário já estiver autenticado, redireciona para o dashboard
  if ((to.name === 'login' || to.name === 'register') && authStore.token) {
    next({ name: 'dashboard' });
    return;
  }

  next(); // Continua para a próxima rota
});
// --- FIM DO MIDDLEWARE ---

export default router;
