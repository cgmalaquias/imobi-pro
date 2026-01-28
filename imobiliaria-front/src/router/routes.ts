// FILE: frontend/src/router/routes.ts
import type { RouteRecordRaw } from 'vue-router';
import { authService } from 'src/services/auth.service'; // Importar authService para o guard

const routes: RouteRecordRaw[] = [
  // ===== ROTAS PÚBLICAS (Site do Cliente Final) =====
  {
    path: '/',
    component: () => import('layouts/SiteLayout.vue'),
    children: [
      {
        path: '',
        name: 'public-home',
        component: () => import('pages/site/SiteHomePage.vue'),
        meta: { title: 'Início' }
      },
      {
        path: 'imoveis',
        name: 'public-properties',
        component: () => import('pages/public/PublicPropertyListPage.vue'),
        meta: { title: 'Imóveis' }
      },
      {
        path: 'imovel/:id',
        name: 'public-property-details',
        component: () => import('pages/public/PublicPropertyDetailsPage.vue'),
        meta: { title: 'Detalhes do Imóvel' }
      },
      {
        path: 'contato',
        name: 'contact',
        component: () => import('pages/ContactPage.vue'),
        meta: { title: 'Contato' }
      },
    ],
  },

  // ===== ROTAS DE AUTENTICAÇÃO (Login/Registro) =====
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

  // ===== REDIRECIONAMENTOS PARA MANTER COMPATIBILIDADE (se necessário) =====
  {
    path: '/login',
    redirect: '/auth/login'
  },
  {
    path: '/register',
    redirect: '/auth/register'
  },

  // ===== ROTAS ADMINISTRATIVAS (Requer Autenticação) =====
  {
    path: '/admin',
    component: () => import('layouts/MainLayout.vue'),
    meta: { requiresAuth: true }, // Todas as rotas filhas requerem autenticação
    children: [
      {
        path: '',
        name: 'dashboard',
        component: () => import('pages/DashboardPage.vue'),
        meta: { title: 'Dashboard' }
      },
      {
        path: 'properties',
        name: 'admin-properties',
        component: () => import('pages/properties/PropertyListPage.vue'),
        meta: { title: 'Imóveis' }
      },
      {
        path: 'properties/create',
        name: 'admin-property-create',
        component: () => import('pages/properties/PropertyFormPage.vue'),
        meta: { title: 'Cadastrar Imóvel' }
      },
      {
        path: 'properties/:id',
        name: 'admin-property-details',
        component: () => import('pages/properties/PropertyDetailPage.vue'),
        meta: { title: 'Detalhes do Imóvel' }
      },
      {
        path: 'properties/:id/edit',
        name: 'admin-property-edit',
        component: () => import('pages/properties/PropertyFormPage.vue'),
        meta: { title: 'Editar Imóvel', roles: ['ADMIN'] }, // Apenas ADMIN pode editar
      },
      {
        path: 'leads',
        name: 'admin-leads',
        component: () => import('pages/leads/LeadListPage.vue'),
        meta: { title: 'Visitas/Leads' }
      },
      {
        path: 'leads/:id',
        name: 'admin-lead-details',
        component: () => import('pages/leads/LeadDetailPage.vue'),
        meta: { title: 'Detalhes do Lead' }
      },
      {
        path: 'users',
        name: 'admin-users',
        component: () => import('pages/users/UserListPage.vue'), // Renomeado para UserListPage
        meta: { title: 'Usuários', roles: ['ADMIN'] } // Apenas ADMIN pode gerenciar usuários
      },
      {
        path: 'profile',
        name: 'admin-profile',
        component: () => import('pages/ProfilePage.vue'),
        meta: { title: 'Meu Perfil' }
      }
    ]
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue')
  }
];

export default routes;
