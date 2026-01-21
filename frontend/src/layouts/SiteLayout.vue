<template>
  <q-layout view="hHh lpR fFf">
    <!-- Top Bar com informações de contato -->
    <q-header elevated class="bg-brown-9" style="min-height: 40px">
      <q-toolbar dense class="q-px-md">
        <div class="row full-width items-center justify-between text-caption">
          <div class="row items-center q-gutter-x-md">
            <div class="row items-center">
              <q-icon name="badge" size="xs" class="q-mr-xs" />
              <span>CRECI F 34809</span>
            </div>
            <div class="row items-center">
              <q-icon name="phone" size="xs" class="q-mr-xs" />
              <span>(41) 99585-0231</span>
            </div>
          </div>
          <div class="row items-center">
            <q-icon name="schedule" size="xs" class="q-mr-xs" />
            <span>Seg a Sex das 9h às 18h</span>
          </div>
        </div>
      </q-toolbar>
    </q-header>

    <!-- Header Principal com Logo e Menu -->
    <q-header elevated class="bg-white text-brown-9" style="margin-top: 40px">
      <q-toolbar class="q-px-md q-py-sm">
        <q-toolbar-title class="cursor-pointer" @click="router.push({ name: 'site-home' })">
          <div class="row items-center">
            <div class="text-center">
              <div
                class="text-h5 text-weight-bold"
                style="font-family: 'Brush Script MT', cursive; color: #c8a882; line-height: 1.2"
              >
                Karina Carvalho
              </div>
              <div
                class="text-caption text-uppercase text-weight-medium"
                style="color: #c8a882; letter-spacing: 2px"
              >
                Corretora de Imóveis
              </div>
              <div class="text-caption" style="color: #999; font-size: 9px">CRECI F 34809</div>
            </div>
          </div>
        </q-toolbar-title>

        <q-space />

        <!-- Menu de Navegação -->
        <q-btn
          flat
          label="Home"
          @click="router.push({ name: 'site-home' })"
          class="q-mx-xs text-weight-medium header-link"
        />
        <q-btn flat label="Sobre Nós" class="q-mx-xs text-weight-medium header-link" />
        <q-btn flat label="Blog" class="q-mx-xs text-weight-medium header-link" />
        <q-btn flat label="Contato" class="q-mx-xs text-weight-medium header-link" />

        <q-separator vertical inset class="q-mx-md" />

        <!-- Busca por Código -->
        <q-input dense outlined placeholder="Busca por código" class="q-ml-sm" style="width: 200px">
          <template v-slot:prepend>
            <q-icon name="search" />
          </template>
        </q-input>

        <q-separator vertical inset class="q-mx-md" />

        <!-- Botão Admin -->
        <q-btn
          flat
          icon="login"
          label="Admin"
          @click="router.push({ name: 'login' })"
          class="q-ml-sm"
        />
      </q-toolbar>
    </q-header>

    <!-- Conteúdo Principal -->
    <q-page-container style="margin-top: 120px">
      <router-view />

      <!-- Footer (não fixo, dentro do page-container) -->
      <footer class="site-footer bg-brown-10 text-white">
        <div class="site-footer__content q-pa-lg">
          <div class="row full-width q-col-gutter-lg">
            <!-- Coluna 1: Sobre -->
            <div class="col-12 col-md-3">
              <div class="text-h6 q-mb-md text-weight-bold" style="color: #c8a882">Sobre</div>
              <p class="text-caption">
                Karina Carvalho é uma corretora de imóveis comprometida em encontrar o imóvel
                perfeito para você. Com anos de experiência no mercado, oferecemos um atendimento
                personalizado e de qualidade.
              </p>
            </div>

            <!-- Coluna 2: Horário de Atendimento -->
            <div class="col-12 col-md-3">
              <div class="text-h6 q-mb-md text-weight-bold" style="color: #c8a882">
                Horário de Atendimento
              </div>
              <p class="text-caption q-mb-xs">Segunda a Sexta: 9h às 18h</p>
              <p class="text-caption q-mb-xs">Sábado: 9h às 13h</p>
              <p class="text-caption">Domingo: Fechado</p>
            </div>

            <!-- Coluna 3: Logo e CRECI -->
            <div class="col-12 col-md-3 text-center">
              <div
                class="text-h5 text-weight-bold q-mb-sm"
                style="font-family: 'Brush Script MT', cursive; color: #c8a882"
              >
                Karina Carvalho
              </div>
              <div class="text-caption text-uppercase" style="color: #c8a882; letter-spacing: 2px">
                Corretora de Imóveis
              </div>
              <div class="text-caption q-mt-sm" style="color: #ccc">CRECI F 34809</div>
            </div>

            <!-- Coluna 4: Redes Sociais -->
            <div class="col-12 col-md-3">
              <div class="text-h6 q-mb-md text-weight-bold" style="color: #c8a882">
                Redes Sociais
              </div>
              <div class="row q-gutter-sm">
                <q-btn
                  round
                  flat
                  icon="fab fa-facebook"
                  size="md"
                  color="white"
                  href="https://facebook.com"
                  target="_blank"
                />
                <q-btn
                  round
                  flat
                  icon="fab fa-instagram"
                  size="md"
                  color="white"
                  href="https://instagram.com"
                  target="_blank"
                />
                <q-btn
                  round
                  flat
                  icon="fab fa-whatsapp"
                  size="md"
                  color="white"
                  href="https://wa.me/5541995850231"
                  target="_blank"
                />
              </div>
              <div class="q-mt-md text-caption">
                <div class="q-mb-xs">
                  <q-icon name="phone" size="xs" class="q-mr-xs" />
                  (41) 99585-0231
                </div>
                <div>
                  <q-icon name="email" size="xs" class="q-mr-xs" />
                  contato@karinacarvalho.com.br
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Copyright -->
        <q-separator color="brown-8" />
        <div class="site-footer__copyright q-pa-md text-center">
          <div class="text-caption text-grey-5">
            © 2024 Karina Carvalho Corretora de Imóveis - Todos os direitos reservados
          </div>
        </div>
      </footer>
    </q-page-container>

    <!-- Botão Flutuante WhatsApp -->
    <q-page-sticky position="bottom-right" :offset="[18, 18]">
      <q-btn
        fab
        icon="fab fa-whatsapp"
        color="positive"
        size="lg"
        href="https://wa.me/5541995850231"
        target="_blank"
      />
    </q-page-sticky>
  </q-layout>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router';

const router = useRouter();
</script>

<style scoped>
/* Estilos personalizados para a fonte da logo */
@import url('https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap');

/* marrom/bege claro da logo */
:root {
  --brand-color: #c8a882;
}

.header-link {
  color: var(--brand-color) !important;
}

.header-link:hover {
  background-color: rgba(200, 168, 130, 0.12); /* leve highlight */
}

.site-footer {
  width: 100%;
}

.site-footer__content {
  max-width: 1200px;
  margin: 0 auto;
}

.site-footer__copyright {
  background-color: rgba(0, 0, 0, 0.2);
}
</style>
