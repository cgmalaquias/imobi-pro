import { route } from 'quasar/wrappers';
import {
  createMemoryHistory,
  createRouter,
  createWebHashHistory,
  createWebHistory,
} from 'vue-router';

import routes from './routes';
import { authService } from 'src/services/auth.service';

export default route(function (/* { store, ssrContext } */) {
  const createHistory = process.env.SERVER
    ? createMemoryHistory
    : (process.env.VUE_ROUTER_MODE === 'history' ? createWebHistory : createWebHashHistory);

  const Router = createRouter({
    scrollBehavior: () => ({ left: 0, top: 0 }),
    routes,
    history: createHistory(process.env.VUE_ROUTER_BASE),
  });

  // Guard de autenticação
  Router.beforeEach((to, from, next) => {
    const isAuthenticated = authService.isAuthenticated();
    const requiresAuth = to.matched.some(record => record.meta.requiresAuth);

    if (requiresAuth && !isAuthenticated) {
      // Redirecionar para login se a rota requer autenticação
      next('/auth/login');
    } else if ((to.path === '/auth/login' || to.path === '/login') && isAuthenticated) {
      // Se já está autenticado e tenta acessar login, redirecionar para admin
      next('/admin');
    } else {
      next();
    }
  });

  return Router;
});
