import type { RouteRecordRaw } from 'vue-router';

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    component: () => import('layouts/SiteLayout.vue'),
    children: [
      {
        path: '',
        name: 'site-home',
        component: () => import('pages/site/SiteHomePage.vue'),
      },
      {
        path: 'imoveis',
        name: 'public-properties',
        component: () => import('pages/public/PublicPropertyListPage.vue'),
      },
      {
        path: 'imovel/:id',
        name: 'public-property-details',
        component: () => import('pages/public/PublicPropertyDetailsPage.vue'),
      },
      {
        path: 'contato',
        name: 'contact',
        component: () => import('pages/ContactPage.vue'),
      },
    ],
  },

  // ===== ROTAS DE AUTENTICAÇÃO (com AuthLayout) =====
  {
    path: '/auth',
    component: () => import('layouts/AuthLayout.vue'),
    children: [
      {
        path: 'login',
        name: 'login',
        component: () => import('pages/auth/LoginPage.vue'),
        meta: { title: 'Login' }
      },
      {
        path: 'register',
        name: 'register',
        component: () => import('pages/auth/RegisterPage.vue'),
        meta: { title: 'Cadastro' }
      },
    ]
  },

  // ===== REDIRECIONAMENTOS PARA MANTER COMPATIBILIDADE =====
  {
    path: '/login',
    redirect: '/auth/login'
  },
  {
    path: '/register',
    redirect: '/auth/register'
  },

  // ===== ROTAS ADMINISTRATIVAS =====
  {
    path: '/admin',
    component: () => import('layouts/MainLayout.vue'),
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        name: 'dashboard',
        component: () => import('pages/DashboardPage.vue'),
        meta: { title: 'Dashboard' }
      },
      {
        path: 'properties',
        name: 'properties',
        component: () => import('pages/properties/PropertyListPage.vue'),
        meta: { title: 'Imóveis' }
      },
      {
        path: 'properties/create',
        name: 'property-create',
        component: () => import('pages/properties/PropertyFormPage.vue'),
        meta: { title: 'Cadastrar Imóvel' }
      },
      {
        path: 'properties/:id',
        name: 'property-details',
        component: () => import('pages/properties/PropertyDetailPage.vue'),
        meta: { title: 'Detalhes do Imóvel' }
      },
      {
        path: 'properties/:id/edit',
        name: 'property-edit',
        component: () => import('pages/properties/PropertyFormPage.vue'),
        meta: { title: 'Editar Imóvel', requiresAuth: true, roles: ['ADMIN'] },
      },
      // {
      //   path: 'clients',
      //   name: 'clients',
      //   component: () => import('pages/clients/ClientListPage.vue'),
      //   meta: { title: 'Clientes' }
      // },
      // {
      //   path: 'clients/create',
      //   name: 'client-create',
      //   component: () => import('pages/clients/ClientFormPage.vue'),
      //   meta: { title: 'Cadastrar Cliente' }
      // },
      // {
      //   path: 'clients/:id',
      //   name: 'client-detail',
      //   component: () => import('pages/clients/ClientDetailPage.vue'),
      //   meta: { title: 'Detalhes do Cliente' }
      // },
      {
        path: 'leads',
        name: 'leads',
        component: () => import('pages/leads/LeadListPage.vue'),
        meta: { title: 'Leads' }
      },
      {
        path: 'leads/create',
        name: 'lead-create',
        component: () => import('pages/leads/LeadFormPage.vue'),
        meta: { title: 'Cadastrar Lead' }
      },
      {
        path: 'leads/:id',
        name: 'lead-detail',
        component: () => import('pages/leads/LeadDetailPage.vue'),
        meta: { title: 'Detalhes do Lead' }
      },
      {
        path: 'users',
        name: 'users',
        component: () => import('pages/UsersPage.vue'),
        meta: { title: 'Usuários', requiresAdmin: true }
      },
      {
        path: 'profile',
        name: 'profile',
        component: () => import('pages/ProfilePage.vue'),
        meta: { title: 'Perfil' }
      }
    ]
  },
{
  path: '/test',
  component: () => import('layouts/AuthLayout.vue'),
  children: [
    {
      path: '',
      component: () => import('pages/TestPage.vue'),
    }
  ]
},

  // ===== PÁGINA 404 =====
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue')
  }
];

export default routes;
