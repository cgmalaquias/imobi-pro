# Etapa 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

# Copiar dependências
COPY package*.json ./
COPY prisma ./prisma/

# Instalar todas as dependências (incluindo dev)
RUN npm ci

# Copiar código fonte
COPY . .

# Gerar Prisma Client
RUN npx prisma generate

# Compilar TypeScript
RUN npm run build

# Etapa 2: Produção
FROM node:20-alpine

WORKDIR /app

# Copiar package.json
COPY package*.json ./
COPY prisma ./prisma/

# Instalar apenas dependências de produção
RUN npm ci --only=production && \
    npx prisma generate

# Copiar código compilado da etapa anterior
COPY --from=builder /app/dist ./dist

# Criar pasta uploads
RUN mkdir -p /app/uploads && chmod 777 /app/uploads

EXPOSE 3000

# Comando de inicialização
CMD ["sh", "-c", "npx prisma migrate deploy && node dist/server.js"]
