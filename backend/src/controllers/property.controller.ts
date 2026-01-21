import { Request, Response } from 'express';
import prisma from '../config/prisma';
import { Decimal } from '@prisma/client/runtime/library'; // Importar Decimal
import { PropertyType, PropertyStatus, TransactionType } from '@prisma/client'; // Importar enums do Prisma
import path from 'path';
import fs from 'fs';

// Helper para lidar com upload de arquivos (se houver)
const handleFileUpload = (req: Request): { url: string; order?: number }[] => {
  const files = req.files as Express.Multer.File[];
  if (!files || files.length === 0) {
    return [];
  }
  return files.map((file, index) => ({
    url: `/uploads/${file.filename}`,
    order: index
  }));
};

// Listar imóveis
export const getProperties = async (req: Request, res: Response): Promise<void> => {
  try {
    const {
      page = 1,
      limit = 10,
      type,
      city,
      status,
      featured,
      search
    } = req.query;

    const skip = (Number(page) - 1) * Number(limit);

    const where: any = {};

    if (type) where.type = type;
    if (status) where.status = status;
    if (city) where.city = { contains: city as string, mode: 'insensitive' };
    if (featured !== undefined) where.featured = featured === 'true';

    if (search) {
      where.OR = [
        { title: { contains: search as string, mode: 'insensitive' } },
        { description: { contains: search as string, mode: 'insensitive' } },
        { neighborhood: { contains: search as string, mode: 'insensitive' } },
        { city: { contains: search as string, mode: 'insensitive' } }
      ];
    }

    const [properties, total] = await Promise.all([
      prisma.property.findMany({
        where,
        skip,
        take: Number(limit),
        orderBy: { createdAt: 'desc' },
        include: {
          images: {
            orderBy: { order: 'asc' }
          },
          user: {
            select: {
              id: true,
              name: true,
              email: true
            }
          }
        }
      }),
      prisma.property.count({ where })
    ]);

    const propertiesWithFullUrls = properties.map(property => ({
      ...property,
      images: property.images.map(image => ({
        ...image,
        url: `${req.protocol}://${req.get('host')}${image.url}`
      }))
    }));

    res.json({
      properties: propertiesWithFullUrls,
      total,
      page: Number(page),
      totalPages: Math.ceil(total / Number(limit))
    });
  } catch (error: unknown) { // Usar unknown para erro de catch
    console.error('❌ Erro ao buscar imóveis:', error);
    res.status(500).json({ message: 'Erro ao buscar imóveis' });
  }
};

// Buscar imóvel por ID
export const getPropertyById = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const property = await prisma.property.findUnique({
      where: { id },
      include: {
        images: {
          orderBy: { order: 'asc' }
        },
        user: {
          select: {
            id: true,
            name: true,
            email: true
          }
        }
      }
    });

    if (!property) {
      res.status(404).json({ message: 'Imóvel não encontrado' });
      return;
    }

    const propertyWithFullUrls = {
      ...property,
      images: property.images.map(image => ({
        ...image,
        url: `${req.protocol}://${req.get('host')}${image.url}`
      }))
    };

    res.json(propertyWithFullUrls);
  } catch (error: unknown) {
    console.error('❌ Erro ao buscar imóvel:', error);
    res.status(500).json({ message: 'Erro ao buscar imóvel' });
  }
};

// Criar imóvel
export const createProperty = async (req: Request, res: Response): Promise<void> => {
  try {
    const userId = req.user?.id;

    if (!userId) {
      res.status(401).json({ message: 'Usuário não autenticado' });
      return;
    }

    // Processar novas imagens (se houver upload)
    const newImageUrls = handleFileUpload(req);

    // Preparar dados para o Prisma, convertendo tipos e garantindo consistência
    const {
      title, description, address, neighborhood, city, state, zipCode,
      priceSale, priceRent, type, status, transactionType, bedrooms, bathrooms,
      garage, areaTotal, areaBuilt, featured
    } = req.body;

    const dataToCreate: any = { // Usar any para flexibilidade na construção do objeto
      title,
      description,
      address,
      neighborhood,
      city,
      state,
      zipCode,
      type: type as PropertyType,
      status: status as PropertyStatus,
      transactionType: transactionType ? (transactionType as TransactionType) : undefined,
      bedrooms: bedrooms ? parseInt(bedrooms) : undefined,
      bathrooms: bathrooms ? parseInt(bathrooms) : undefined,
      garage: garage ? parseInt(garage) : undefined,
      areaTotal: areaTotal ? new Decimal(parseFloat(areaTotal)) : undefined,
      areaBuilt: areaBuilt ? new Decimal(parseFloat(areaBuilt)) : undefined,
      priceSale: priceSale ? new Decimal(parseFloat(priceSale)) : undefined,
      priceRent: priceRent ? new Decimal(parseFloat(priceRent)) : undefined,
      featured: featured === 'true', // Converter string 'true'/'false' para boolean
      userId
    };

    const property = await prisma.property.create({
      data: {
        ...dataToCreate,
        images: {
          create: newImageUrls.map(img => ({ url: img.url, order: img.order || 0 }))
        }
      },
      include: {
        images: true,
        user: {
          select: {
            id: true,
            name: true,
            email: true
          }
        }
      }
    });

    res.status(201).json(property);
  } catch (error: unknown) {
    console.error('❌ Erro ao criar imóvel:', error);
    res.status(500).json({ message: 'Erro ao criar imóvel' });
  }
};

// Atualizar imóvel
export const updateProperty = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const userId = req.user?.id;

    if (!userId) {
      res.status(401).json({ message: 'Usuário não autenticado.' });
      return;
    }

    const {
      title, description, address, neighborhood, city, state, zipCode,
      priceSale, priceRent, type, status, transactionType, bedrooms, bathrooms,
      garage, areaTotal, areaBuilt, featured
    } = req.body;

    const dataToUpdate: any = {}; // Usar any para flexibilidade na construção do objeto

    if (title !== undefined) dataToUpdate.title = title;
    if (description !== undefined) dataToUpdate.description = description;
    if (address !== undefined) dataToUpdate.address = address;
    if (neighborhood !== undefined) dataToUpdate.neighborhood = neighborhood;
    if (city !== undefined) dataToUpdate.city = city;
    if (state !== undefined) dataToUpdate.state = state;
    if (zipCode !== undefined) dataToUpdate.zipCode = zipCode;

    // Conversão de ENUMS
    if (type !== undefined) dataToUpdate.type = type as PropertyType;
    if (status !== undefined) dataToUpdate.status = status as PropertyStatus;
    if (transactionType !== undefined) dataToUpdate.transactionType = transactionType as TransactionType;

    // Conversão de NÚMEROS (Int e Decimal)
    // Verificar se o valor não é undefined, null ou string vazia antes de converter
    if (bedrooms !== undefined && bedrooms !== null && bedrooms !== '') dataToUpdate.bedrooms = parseInt(bedrooms);
    if (bathrooms !== undefined && bathrooms !== null && bathrooms !== '') dataToUpdate.bathrooms = parseInt(bathrooms);
    if (garage !== undefined && garage !== null && garage !== '') dataToUpdate.garage = parseInt(garage);
    if (areaTotal !== undefined && areaTotal !== null && areaTotal !== '') dataToUpdate.areaTotal = new Decimal(parseFloat(areaTotal));
    if (areaBuilt !== undefined && areaBuilt !== null && areaBuilt !== '') dataToUpdate.areaBuilt = new Decimal(parseFloat(areaBuilt));
    if (priceSale !== undefined && priceSale !== null && priceSale !== '') dataToUpdate.priceSale = new Decimal(parseFloat(priceSale));
    if (priceRent !== undefined && priceRent !== null && priceRent !== '') dataToUpdate.priceRent = new Decimal(parseFloat(priceRent));

    // Conversão de BOOLEAN
    if (featured !== undefined) dataToUpdate.featured = featured === true || featured === 'true';

    const property = await prisma.property.update({
      where: { id },
      data: dataToUpdate,
      include: {
        images: {
          orderBy: { order: 'asc' }
        },
        user: {
          select: {
            id: true,
            name: true,
            email: true
          }
        }
      }
    });

    const propertyWithFullUrls = {
      ...property,
      images: property.images.map(image => ({
        ...image,
        url: `${req.protocol}://${req.get('host')}${image.url}`
      }))
    };

    res.json(propertyWithFullUrls);
  } catch (error: unknown) {
    console.error('❌ Erro ao atualizar imóvel:', error);
    res.status(500).json({ message: 'Erro ao atualizar imóvel' });
  }
};

// Excluir imóvel
export const deleteProperty = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    await prisma.property.delete({
      where: { id }
    });

    res.json({ message: 'Imóvel excluído com sucesso' });
  } catch (error: unknown) {
    console.error('❌ Erro ao excluir imóvel:', error);
    res.status(500).json({ message: 'Erro ao excluir imóvel' });
  }
};

// Alternar destaque
export const toggleFeatured = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const property = await prisma.property.findUnique({
      where: { id }
    });

    if (!property) {
      res.status(404).json({ message: 'Imóvel não encontrado' });
      return;
    }

    const updatedProperty = await prisma.property.update({
      where: { id },
      data: { featured: !property.featured },
      include: {
        images: {
          orderBy: { order: 'asc' }
        }
      }
    });

    res.json(updatedProperty);
  } catch (error: unknown) {
    console.error('❌ Erro ao atualizar destaque:', error);
    res.status(500).json({ message: 'Erro ao atualizar destaque' });
  }
};

// Adicionei estas funções para as rotas de imagem que você tem no property.routes.ts
export const uploadImages = async (req: Request, res: Response): Promise<void> => {
  try {
    const { propertyId } = req.params;
    const imageUrls = handleFileUpload(req);

    // Se o propertyId for válido, associar as imagens ao imóvel
    if (propertyId) {
      const createdImages = await prisma.propertyImage.createMany({
        data: imageUrls.map(img => ({
          propertyId: propertyId,
          url: img.url,
          order: img.order || 0
        }))
      });

      // Buscar as imagens criadas para retornar com IDs e outros dados
      const imagesWithDetails = await prisma.propertyImage.findMany({
        where: {
          propertyId: propertyId,
          url: {
            in: imageUrls.map(img => img.url)
          }
        }
      });

      res.status(200).json({ message: 'Imagens enviadas e associadas com sucesso!', images: imagesWithDetails });
    } else {
      res.status(400).json({ message: 'ID do imóvel não fornecido.' });
    }
  } catch (error: unknown) {
    console.error('❌ Erro ao fazer upload de imagens:', error);
    res.status(500).json({ message: 'Erro interno do servidor ao fazer upload de imagens.' });
  }
};

export const deleteImage = async (req: Request, res: Response): Promise<void> => {
  try {
    const { imageId } = req.params;
    const image = await prisma.propertyImage.findUnique({ where: { id: imageId } });

    if (!image) {
      res.status(404).json({ message: 'Imagem não encontrada.' });
      return;
    }

    const imagePath = path.join(__dirname, '../../uploads', path.basename(image.url));
    if (fs.existsSync(imagePath)) {
      fs.unlinkSync(imagePath);
    }
    await prisma.propertyImage.delete({ where: { id: imageId } });

    res.status(200).json({ message: 'Imagem excluída com sucesso.' });
  } catch (error: unknown) {
    console.error('❌ Erro ao deletar imagem:', error);
    res.status(500).json({ message: 'Erro interno do servidor ao deletar imagem.' });
  }
};
