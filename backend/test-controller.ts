    // backend/test-controller.ts
    import { register, login, getMe } from './src/controllers/auth.controller';

    console.log('--- Verificando auth.controller.ts ---');
    console.log('Tipo de register:', typeof register);
    console.log('Tipo de login:', typeof login);
    console.log('Tipo de getMe:', typeof getMe);

    if (typeof register !== 'function') {
      console.error('❌ register NÃO é uma função!');
    }
    if (typeof login !== 'function') {
      console.error('❌ login NÃO é uma função!');
    }
    if (typeof getMe !== 'function') {
      console.error('❌ getMe NÃO é uma função!');
    }
    console.log('--- Fim da verificação do auth.controller.ts ---');
