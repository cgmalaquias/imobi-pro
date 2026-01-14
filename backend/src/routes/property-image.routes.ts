import { Router } from 'express';
import { authenticate } from '../middlewares/auth.middleware';
import { uploadImages, deleteImage, updateImageOrder } from '../controllers/property-image.controller';
import upload from '../config/multer'; // <-- Importação do Multer

const router = Router();

// Rotas protegidas para imagens de imóveis
router.post('/:propertyId/upload', authenticate, upload.array('images', 10), uploadImages); // <-- Linha 9 ou próxima
router.delete('/:id', authenticate, deleteImage);
router.patch('/:id/order', authenticate, updateImageOrder);

export default router;
