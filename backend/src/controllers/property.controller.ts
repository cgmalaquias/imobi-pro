import { Request, Response } from 'express';
import prisma from '../config/prisma';

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
  } catch (error) {
    console.error('Erro ao buscar imóveis:', error);
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
  } catch (error) {
    console.error('Erro ao buscar imóvel:', error);
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

    const property = await prisma.property.create({
      data: {
        ...req.body,
        userId
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
  } catch (error) {
    console.error('Erro ao criar imóvel:', error);
    res.status(500).json({ message: 'Erro ao criar imóvel' });
  }
};

// Atualizar imóvel
export const updateProperty = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const property = await prisma.property.update({
      where: { id },
      data: req.body,
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
  } catch (error) {
    console.error('Erro ao atualizar imóvel:', error);
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
  } catch (error) {
    console.error('Erro ao excluir imóvel:', error);
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
  } catch (error) {
    console.error('Erro ao atualizar destaque:', error);
    res.status(500).json({ message: 'Erro ao atualizar destaque' });
  }
};
