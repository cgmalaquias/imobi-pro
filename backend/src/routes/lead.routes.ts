// backend/src/routes/lead.routes.ts
import { Router } from 'express';
import {
  getLeads,
  getLeadById,
  createLead,
  updateLead,
  deleteLead
} from '../controllers/lead.controller';
import { authenticate } from '../middlewares/auth.middleware';

// DEBUG: Verifique os tipos das funções importadas
console.log('🔍 Debug lead.routes.ts:');
console.log('  getLeads:', typeof getLeads);
console.log('  getLeadById:', typeof getLeadById);
console.log('  createLead:', typeof createLead);
console.log('  updateLead:', typeof updateLead);
console.log('  deleteLead:', typeof deleteLead);
console.log('  authenticate:', typeof authenticate);

const router = Router();

// Rotas protegidas para leads
router.get('/', authenticate, getLeads); // Linha 19 ou próxima
router.get('/:id', authenticate, getLeadById);
router.post('/', authenticate, createLead);
router.put('/:id', authenticate, updateLead);
router.delete('/:id', authenticate, deleteLead);

export default router;
