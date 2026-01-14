import { boot } from 'quasar/wrappers';
import { createApp } from 'vue';
import { createPinia } from 'pinia';

import App from './App.vue';
import router from './router';

export default boot(({ app }) => {
  const pinia = createPinia();

  app.use(pinia);
  app.use(router);

  app.mount('#app');
});
