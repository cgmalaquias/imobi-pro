import { PrismaClient } from '@prisma/client';

// Prevenir múltiplas instâncias do Prisma Client em desenvolvimento
const globalForPrisma = global as unknown as { prisma: PrismaClient };

const prisma =
  globalForPrisma.prisma ||
  new PrismaClient({
    log: process.env.NODE_ENV === 'development' 
      ? ['query', 'error', 'warn'] 
      : ['error'],
    errorFormat: 'pretty',
  });

if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = prisma;
}

// Função para testar conexão
export const testConnection = async (): Promise<void> => {
  try {
    await prisma.$connect();
    console.log('✅ Conexão com o banco de dados estabelecida com sucesso!');
  } catch (error) {
    console.error('❌ Erro ao conectar com o banco de dados:', error);
    process.exit(1);
  }
};

// Graceful shutdown
export const disconnectPrisma = async (): Promise<void> => {
  await prisma.$disconnect();
  console.log('🔌 Conexão com o banco de dados encerrada');
};

export default prisma;
