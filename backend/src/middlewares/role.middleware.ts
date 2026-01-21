import { Request, Response, NextFunction } from 'express';

export const authorizeRole = (roles: string[]) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    if (!req.user || !req.user.role) {
      res.status(403).json({ message: 'Acesso negado. Informações de usuário não disponíveis.' });
      return;
    }

    if (!roles.includes(req.user.role)) {
      res.status(403).json({ message: `Acesso negado. Você não tem permissão para acessar esta rota. Role: ${req.user.role}` });
      return;
    }

    next();
  };
};
