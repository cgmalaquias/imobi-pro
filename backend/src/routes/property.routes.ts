    import { Router } from 'express';
    import {
      getProperties,
      getPropertyById,
      createProperty,
      updateProperty,
      deleteProperty,
      toggleFeatured
    } from '../controllers/property.controller';
    import { authenticate } from '../middlewares/auth.middleware'; // <-- Importação correta

    const router = Router();

    // Rotas públicas
    router.get('/', getProperties);
    router.get('/:id', getPropertyById);

    // Rotas protegidas
    router.post('/', authenticate, createProperty); // <-- Uso do middleware
    router.put('/:id', authenticate, updateProperty);
    router.delete('/:id', authenticate, deleteProperty);
    router.patch('/:id/featured', authenticate, toggleFeatured);

    export default router;
