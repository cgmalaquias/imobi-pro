// backend/src/routes/auth.routes.ts
import { Router } from 'express';
import { register, login, getMe } from '../controllers/auth.controller';
import { authenticate } from '../middlewares/auth.middleware';

// DEBUG: Verifique os tipos das funções importadas
console.log('🔍 Debug auth.routes.ts:');
console.log('  register:', typeof register);
console.log('  login:', typeof login);
console.log('  getMe:', typeof getMe);
console.log('  authenticate:', typeof authenticate);

const router = Router();

// Rotas de autenticação
router.post('/register', register);
router.post('/login', login);
router.get('/me', authenticate, getMe); // Linha 26

export default router;
