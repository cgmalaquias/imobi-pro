import { Router } from 'express';
import {
  getProperties,
  getPropertyById,
  createProperty,
  updateProperty,
  deleteProperty,
  toggleFeatured,
  uploadImages,
  deleteImage
} from '../controllers/property.controller';
import { authenticate } from '../middlewares/auth.middleware';
import { authorizeRole } from '../middlewares/role.middleware';
import multer from 'multer';
import path from 'path';
import fs from 'fs'; // Importar fs para criar diretório

const router = Router();

// Configuração do Multer para upload de imagens
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadPath = path.join(__dirname, '../../uploads');
    // Cria a pasta 'uploads' se ela não existir
    if (!fs.existsSync(uploadPath)) {
      fs.mkdirSync(uploadPath, { recursive: true });
    }
    cb(null, uploadPath);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ storage: storage });

// Rotas públicas (listagem e visualização de imóveis)
router.get('/', getProperties);
router.get('/:id', getPropertyById);

// Rotas protegidas por autenticação e autorização
// Apenas ADMIN pode criar, atualizar, deletar e gerenciar destaque
router.post('/', authenticate, authorizeRole(['ADMIN']), upload.array('images', 5), createProperty); // ✅ createProperty agora espera multipart/form-data
router.put('/:id', authenticate, authorizeRole(['ADMIN']), updateProperty); // ✅ updateProperty espera JSON, sem multer
router.delete('/:id', authenticate, authorizeRole(['ADMIN']), deleteProperty);
router.patch('/:id/featured', authenticate, authorizeRole(['ADMIN']), toggleFeatured);

// Rotas para upload e exclusão de imagens (também protegidas)
router.post('/:propertyId/images', authenticate, authorizeRole(['ADMIN']), upload.array('images', 5), uploadImages);
router.delete('/images/:imageId', authenticate, authorizeRole(['ADMIN']), deleteImage);

export default router;
