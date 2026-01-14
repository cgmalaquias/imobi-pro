import { Request, Response } from 'express';
import prisma from '../config/prisma';
import fs from 'fs';
import path from 'path';

// Middleware de upload de imagens (configurado no routes)
// import upload from '../config/multer'; // Não é importado aqui, mas sim no routes

export const uploadImages = async (req: Request, res: Response): Promise<void> => {
  try {
    const { propertyId } = req.params;
    const files = req.files as Express.Multer.File[];

    if (!files || files.length === 0) {
      res.status(400).json({ message: 'Nenhuma imagem foi enviada' });
      return;
    }

    const property = await prisma.property.findUnique({
      where: { id: propertyId }
    });

    if (!property) {
      res.status(404).json({ message: 'Imóvel não encontrado' });
      return;
    }

    const lastImage = await prisma.propertyImage.findFirst({
      where: { propertyId },
      orderBy: { order: 'desc' }
    });

    let currentOrder = lastImage ? lastImage.order + 1 : 0;

    const imagePromises = files.map((file) => {
      const url = `/uploads/properties/${file.filename}`;

      return prisma.propertyImage.create({
        data: {
          propertyId,
          url,
          order: currentOrder++
        }
      });
    });

    const images = await Promise.all(imagePromises);

    const imagesWithFullUrls = images.map(image => ({
      ...image,
      url: `${req.protocol}://${req.get('host')}${image.url}`
    }));

    res.status(201).json({
      message: 'Imagens enviadas com sucesso',
      images: imagesWithFullUrls
    });
  } catch (error) {
    console.error('Erro ao fazer upload de imagens:', error);
    res.status(500).json({ message: 'Erro ao fazer upload de imagens' });
  }
};

export const deleteImage = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const image = await prisma.propertyImage.findUnique({
      where: { id }
    });

    if (!image) {
      res.status(404).json({ message: 'Imagem não encontrada' });
      return;
    }

    const filePath = path.join(__dirname, '../../', image.url);

    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
    }

    await prisma.propertyImage.delete({
      where: { id }
    });

    res.json({ message: 'Imagem excluída com sucesso' });
  } catch (error) {
    console.error('Erro ao excluir imagem:', error);
    res.status(500).json({ message: 'Erro ao excluir imagem' });
  }
};

export const updateImageOrder = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const { order } = req.body;

    const image = await prisma.propertyImage.update({
      where: { id },
      data: { order }
    });

    res.json(image);
  } catch (error) {
    console.error('Erro ao atualizar ordem da imagem:', error);
    res.status(500).json({ message: 'Erro ao atualizar ordem da imagem' });
  }
};
