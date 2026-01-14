import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import prisma from '../config/prisma';

// Estender o tipo Request do Express para incluir o usuário autenticado
declare global {
  namespace Express {
    interface Request {
      user?: {
        id: string;
        email: string;
        role: string;
      };
    }
  }
}

interface JwtPayload {
  id: string;
  email: string;
  role: string;
}

// Garante que JWT_SECRET está definido ao iniciar a aplicação
const JWT_SECRET = process.env.JWT_SECRET;
if (!JWT_SECRET) {
  console.error('ERRO CRÍTICO: JWT_SECRET não está definido nas variáveis de ambiente.');
  process.exit(1); // Encerra a aplicação se a chave secreta não estiver configurada
}

export const authenticate = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    // 1. Verificar se o token está presente no cabeçalho Authorization
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      res.status(401).json({ message: 'Acesso negado. Token não fornecido ou mal formatado.' });
      return;
    }

    const token = authHeader.split(' ')[1];

    // 2. Verificar e decodificar o token
    // Usar a constante JWT_SECRET que já foi verificada
    const decoded = jwt.verify(token, JWT_SECRET) as JwtPayload;

    // 3. Buscar o usuário no banco de dados para garantir que ele ainda existe e está ativo
    const user = await prisma.user.findUnique({
      where: { id: decoded.id },
      select: {
        id: true,
        email: true,
        role: true,
        active: true // Verificar se o usuário está ativo
      }
    });

    if (!user || !user.active) {
      res.status(401).json({ message: 'Acesso negado. Usuário não encontrado ou inativo.' });
      return;
    }

    // 4. Anexar as informações do usuário à requisição
    req.user = {
      id: user.id,
      email: user.email,
      role: user.role
    };

    // 5. Continuar para a próxima função middleware ou rota
    next();
  } catch (error) {
    if (error instanceof jwt.TokenExpiredError) {
      res.status(401).json({ message: 'Token expirado. Faça login novamente.' });
    } else if (error instanceof jwt.JsonWebTokenError) {
      res.status(401).json({ message: 'Token inválido. Acesso negado.' });
    } else {
      console.error('Erro na autenticação:', error);
      res.status(500).json({ message: 'Erro interno do servidor na autenticação.' });
    }
  }
};
