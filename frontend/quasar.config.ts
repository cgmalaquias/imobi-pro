/* eslint-env node */

import { configure } from 'quasar/wrappers';
import path from 'path';

export default configure((ctx) => {
  return {
    eslint: {
      warnings: true,
      errors: true
    },

    boot: ['axios'],

    css: ['app.scss'],

    extras: [
      'roboto-font',
      'material-icons'
    ],

    build: {
      target: {
        browser: ['es2019', 'edge88', 'firefox78', 'chrome87', 'safari13.1'],
        node: 'node16'
      },

      vueRouterMode: 'history',

      vitePlugins: [
        ['@intlify/vite-plugin-vue-i18n', {
          include: [path.resolve(__dirname, './src/i18n/**')]
        }]
      ],

      extendViteConf(viteConf) {
        if (viteConf.resolve) {
          viteConf.resolve.alias = {
            ...viteConf.resolve.alias,
            '@': path.resolve(__dirname, './src'),
            '@components': path.resolve(__dirname, './src/components'),
            '@layouts': path.resolve(__dirname, './src/layouts'),
            '@pages': path.resolve(__dirname, './src/pages'),
            '@stores': path.resolve(__dirname, './src/stores'),
            '@boot': path.resolve(__dirname, './src/boot'),
            '@assets': path.resolve(__dirname, './src/assets'),
            '@router': path.resolve(__dirname, './src/router'),
            '@types': path.resolve(__dirname, './src/types')
          };
        }
      }
    },

    devServer: {
      https: false,
      port: 9001, // Sua porta do frontend
      open: false, // Abre o navegador automaticamente
      proxy: {
        // Proxy para todas as requisições que começam com /api
        '/api': {
          target: 'http://localhost:3000', // URL do seu backend
          changeOrigin: true, // Necessário para virtual-hosted sites
          ws: true, // Proxy websockets
          // pathRewrite: { '^/api': '' } // Se suas rotas no backend não tiverem /api
        }
      }
    },

    framework: {
      config: {},

      plugins: [
        'Notify',
        'Dialog',
        'Loading',
        'LoadingBar'
      ]
    },

    animations: [],

    ssr: {
      pwa: false,
      prodPort: 3000,
      middlewares: ['render']
    },

    pwa: {
      workboxMode: 'generateSW',
      injectPwaMetaTags: true,
      swFilename: 'sw.js',
      manifestFilename: 'manifest.json',
      useCredentialsForManifestTag: false
    },

    cordova: {},

    capacitor: {
      hideSplashscreen: true
    },

    electron: {
      inspectPort: 5858,
      bundler: 'packager',
      packager: {},
      builder: {
        appId: 'imobi-system'
      }
    },

    bex: {
      contentScripts: ['my-content-script']
    }
  };
});
