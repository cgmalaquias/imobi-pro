// backend/src/controllers/auth.controller.ts
import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Garante que JWT_SECRET está definido ao iniciar a aplicação
const JWT_SECRET = process.env.JWT_SECRET;
if (!JWT_SECRET) {
  console.error('ERRO CRÍTICO: JWT_SECRET não está definido nas variáveis de ambiente.');
  process.exit(1);
}

// Login de usuário
export const login = async (req: Request, res: Response): Promise<void> => {
  try {
    console.log('DEBUG BACKEND: req.body recebido:', req.body); // Log para ver o payload
    const { email, password } = req.body;
    console.log('DEBUG LOGIN: Tentativa de login para e-mail:', email);

    // Validação básica de entrada
    if (!email || !password) {
      console.log('DEBUG LOGIN: E-mail ou senha não fornecidos.');
      res.status(400).json({ message: 'E-mail e senha são obrigatórios.' });
      return;
    }

    // 1. Buscar usuário pelo e-mail
    const user = await prisma.user.findUnique({ where: { email } });
    console.log('DEBUG LOGIN: Usuário encontrado:', user ? user.email : 'Nenhum');

    if (!user || !user.active) {
      console.log('DEBUG LOGIN: Credenciais inválidas ou usuário inativo para e-mail:', email);
      res.status(401).json({ message: 'Credenciais inválidas ou usuário inativo.' });
      return;
    }

    // 2. Comparar senhas
    const isPasswordValid = await bcrypt.compare(password, user.password);
    console.log('DEBUG LOGIN: Senha válida?', isPasswordValid);

    if (!isPasswordValid) {
      console.log('DEBUG LOGIN: Senha inválida para e-mail:', email);
      res.status(401).json({ message: 'Credenciais inválidas.' });
      return;
    }

    // 3. Gerar token JWT
    console.log('DEBUG LOGIN: Gerando token para usuário:', user.email);
    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      JWT_SECRET,
      { expiresIn: '1d' }
    );
    console.log('DEBUG LOGIN: Token gerado com sucesso.');

    res.json({
      message: 'Login bem-sucedido!',
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        active: user.active,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      },
      token,
    });
  } catch (error: any) { // Usando 'any' temporariamente para o erro, conforme o histórico
    console.error('ERRO NO LOGIN DO BACKEND:', error);
    res.status(500).json({ message: 'Erro ao fazer login.' });
  }
};

// Registro de usuário (exemplo com fetch)
export const register = async (req: Request, res: Response): Promise<void> => {
  try {
    const { name, email, password, phone } = req.body;

    if (!name || !email || !password) {
      res.status(400).json({ message: 'Nome, e-mail e senha são obrigatórios.' });
      return;
    }

    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      res.status(409).json({ message: 'E-mail já cadastrado.' });
      return;
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = await prisma.user.create({
      data: {
        name,
        email,
        password: hashedPassword,
        phone,
        role: 'ADMIN', // Definir um papel padrão
        active: true,
      },
    });

    const token = jwt.sign(
      { id: newUser.id, email: newUser.email, role: newUser.role },
      JWT_SECRET,
      { expiresIn: '1d' }
    );

    res.status(201).json({
      message: 'Usuário registrado com sucesso!',
      user: {
        id: newUser.id,
        name: newUser.name,
        email: newUser.email,
        phone: newUser.phone,
        role: newUser.role,
        active: newUser.active,
        createdAt: newUser.createdAt,
        updatedAt: newUser.updatedAt,
      },
      token,
    });
  } catch (error) {
    console.error('ERRO NO REGISTRO DO BACKEND:', error);
    res.status(500).json({ message: 'Erro ao registrar usuário.' });
  }
};

// Obter dados do usuário logado
export const getMe = async (req: Request, res: Response): Promise<void> => {
  try {
    // O middleware de autenticação (se você tiver um) já teria adicionado o usuário ao req
    // Por simplicidade, vamos assumir que o ID do usuário está no token decodificado
    const userId = (req as any).user?.id; // Assumindo que o ID do usuário é adicionado ao req pelo middleware de auth

    if (!userId) {
      res.status(401).json({ message: 'Não autorizado.' });
      return;
    }

    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        name: true,
        email: true,
        phone: true,
        role: true,
        active: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    if (!user) {
      res.status(404).json({ message: 'Usuário não encontrado.' });
      return;
    }

    res.json({ user });
  } catch (error) {
    console.error('ERRO AO OBTER DADOS DO USUÁRIO:', error);
    res.status(500).json({ message: 'Erro ao obter dados do usuário.' });
  }
};
