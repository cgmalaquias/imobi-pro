// backend/src/routes/client.routes.ts
import { Router } from 'express';
import {
  getClients,
  getClientById,
  createClient,
  updateClient,
  deleteClient
} from '../controllers/client.controller';
import { authenticate } from '../middlewares/auth.middleware';

// DEBUG: Verifique os tipos das funções importadas
console.log('🔍 Debug client.routes.ts:');
console.log('  getClients:', typeof getClients);
console.log('  getClientById:', typeof getClientById);
console.log('  createClient:', typeof createClient);
console.log('  updateClient:', typeof updateClient);
console.log('  deleteClient:', typeof deleteClient);
console.log('  authenticate:', typeof authenticate);

const router = Router();

// Rotas protegidas para clientes
router.get('/', authenticate, getClients); // Linha 17 ou próxima
router.get('/:id', authenticate, getClientById);
router.post('/', authenticate, createClient);
router.put('/:id', authenticate, updateClient);
router.delete('/:id', authenticate, deleteClient);

export default router;
