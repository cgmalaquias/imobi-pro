# Etapa 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

# Copiar dependências
COPY package*.json ./

# Instalar dependências
RUN npm ci

# Copiar código fonte
COPY . .

# Build do Quasar
RUN npm run build

# Etapa 2: Nginx
FROM nginx:alpine

# Remover config padrão
RUN rm /etc/nginx/conf.d/default.conf

# Copiar build
COPY --from=builder /app/dist/spa /usr/share/nginx/html

# Copiar configuração do Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
