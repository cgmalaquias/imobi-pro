// FILE: frontend/src/router/index.ts
import { route } from 'quasar/wrappers';
import {
  createRouter,
  createMemoryHistory,
  createWebHistory,
  createWebHashHistory,
} from 'vue-router';
import routes from './routes';
import { authService } from 'src/services/auth.service'; // Importar authService

/*
 * If not building with SSR (server side rendering)
 * always use createWebHistory() or createWebHashHistory()
 */
export default route(function ({ store }) {
  const createHistory = process.env.SERVER
    ? createMemoryHistory
    : (process.env.VUE_ROUTER_MODE === 'history' ? createWebHistory : createWebHashHistory);

  const Router = createRouter({
    scrollBehavior: () => ({ left: 0, top: 0 }),
    routes,

    // Leave this as is and make changes in quasar.conf.js > build > vueRouterMode
    // quasar.conf.js -> build -> vueRouterBase
    history: createHistory(process.env.VUE_ROUTER_BASE),
  });

  // Global Navigation Guard
  Router.beforeEach(async (to, from, next) => {
    const isAuthenticated = authService.isAuthenticated();
    const user = authService.getUser();
    const requiresAuth = to.matched.some(record => record.meta.requiresAuth);
    const requiredRoles = to.meta.roles as string[] | undefined;

    // Redirecionar para login se a rota requer autenticação e o usuário não está logado
    if (requiresAuth && !isAuthenticated) {
      next({ name: 'login', query: { redirect: to.fullPath } });
      return;
    }

    // Se já está autenticado e tenta acessar login/registro, redirecionar para o dashboard
    if ((to.name === 'login' || to.name === 'register') && isAuthenticated) {
      next({ name: 'dashboard' });
      return;
    }

    // Verificar permissões de role para rotas administrativas
    if (requiresAuth && isAuthenticated && requiredRoles && requiredRoles.length > 0) {
      if (!user || !requiredRoles.includes(user.role)) {
        // Se o usuário não tem a role necessária, redirecionar para o dashboard ou 403
        next({ name: 'dashboard' }); // Ou uma página de "Acesso Negado"
        return;
      }
    }

    // Se tudo estiver ok, continuar
    next();
  });

  return Router;
});
