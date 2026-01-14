import { Request, Response } from 'express';
import prisma from '../config/prisma';

// Listar leads
export const getLeads = async (req: Request, res: Response): Promise<void> => {
  try {
    const { page = 1, limit = 10, search, status, propertyId, clientId } = req.query;
    const skip = (Number(page) - 1) * Number(limit);

    const where: any = {};
    if (search) {
      where.OR = [
        { name: { contains: search as string, mode: 'insensitive' } },
        { email: { contains: search as string, mode: 'insensitive' } },
        { phone: { contains: search as string, mode: 'insensitive' } },
        { notes: { contains: search as string, mode: 'insensitive' } }
      ];
    }
    if (status) where.status = status;
    if (propertyId) where.propertyId = propertyId;
    if (clientId) where.clientId = clientId;

    const [leads, total] = await Promise.all([
      prisma.lead.findMany({
        where,
        skip,
        take: Number(limit),
        orderBy: { createdAt: 'desc' },
        include: {
          property: {
            select: { id: true, title: true }
          },
          client: {
            select: { id: true, name: true }
          }
        }
      }),
      prisma.lead.count({ where })
    ]);

    res.json({
      leads,
      total,
      page: Number(page),
      totalPages: Math.ceil(total / Number(limit))
    });
  } catch (error) {
    console.error('Erro ao buscar leads:', error);
    res.status(500).json({ message: 'Erro ao buscar leads' });
  }
};

// Buscar lead por ID
export const getLeadById = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const lead = await prisma.lead.findUnique({
      where: { id },
      include: {
        property: {
          select: { id: true, title: true }
        },
        client: {
          select: { id: true, name: true }
        }
      }
    });

    if (!lead) {
      res.status(404).json({ message: 'Lead não encontrado' });
      return;
    }
    res.json(lead);
  } catch (error) {
    console.error('Erro ao buscar lead:', error);
    res.status(500).json({ message: 'Erro ao buscar lead' });
  }
};

// Criar lead
export const createLead = async (req: Request, res: Response): Promise<void> => {
  try {
    const lead = await prisma.lead.create({ data: req.body });
    res.status(201).json(lead);
  } catch (error) {
    console.error('Erro ao criar lead:', error);
    res.status(500).json({ message: 'Erro ao criar lead' });
  }
};

// Atualizar lead
export const updateLead = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const lead = await prisma.lead.update({
      where: { id },
      data: req.body
    });
    res.json(lead);
  } catch (error) {
    console.error('Erro ao atualizar lead:', error);
    res.status(500).json({ message: 'Erro ao atualizar lead' });
  }
};

// Excluir lead
export const deleteLead = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    await prisma.lead.delete({ where: { id } });
    res.json({ message: 'Lead excluído com sucesso' });
  } catch (error) {
    console.error('Erro ao excluir lead:', error);
    res.status(500).json({ message: 'Erro ao excluir lead' });
  }
};
