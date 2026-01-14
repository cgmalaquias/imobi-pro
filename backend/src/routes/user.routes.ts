// backend/src/routes/user.routes.ts
import { Router } from 'express';
import {
  getUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  toggleUserStatus
} from '../controllers/user.controller';
import { authenticate } from '../middlewares/auth.middleware';
import { authorize } from '../middlewares/authorize.middleware'; // Se estiver usando

// DEBUG: Verifique os tipos das funções importadas
console.log('🔍 Debug user.routes.ts:');
console.log('  getUsers:', typeof getUsers);
console.log('  getUserById:', typeof getUserById);
console.log('  createUser:', typeof createUser);
console.log('  updateUser:', typeof updateUser);
console.log('  deleteUser:', typeof deleteUser);
console.log('  toggleUserStatus:', typeof toggleUserStatus);
console.log('  authenticate:', typeof authenticate);
console.log('  authorize:', typeof authorize); // Se estiver usando

const router = Router();

// Rotas protegidas para usuários
router.get('/', authenticate, authorize(['ADMIN']), getUsers); // Linha 13 ou próxima
router.get('/:id', authenticate, authorize(['ADMIN', 'CORRETOR']), getUserById);
router.post('/', authenticate, authorize(['ADMIN']), createUser);
router.put('/:id', authenticate, authorize(['ADMIN']), updateUser);
router.delete('/:id', authenticate, authorize(['ADMIN']), deleteUser);
router.patch('/:id/toggle-status', authenticate, authorize(['ADMIN']), toggleUserStatus);

export default router;
