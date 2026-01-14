// backend/src/server.ts
import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import path from 'path';

// Importar rotas
import authRoutes from './routes/auth.routes';
import userRoutes from './routes/user.routes';
import propertyRoutes from './routes/property.routes';
import propertyImageRoutes from './routes/property-image.routes';
import clientRoutes from './routes/client.routes';
import leadRoutes from './routes/lead.routes';

dotenv.config(); // Carrega as variáveis de ambiente do .env

const app = express();
const PORT = process.env.PORT || 3000; // Porta do backend

// Middleware para permitir JSON no corpo das requisições
app.use(express.json());
// Não precisamos de express.urlencoded() se vamos usar JSON exclusivamente

// --- SEÇÃO DE CONFIGURAÇÃO DO CORS (DEVE SER A ÚNICA) ---
app.use(cors({
  origin: '*', //process.env.CORS_ORIGIN || 'http://localhost:9001', // <-- DEVE SER A PORTA DO SEU FRONTEND
  credentials: true, // Permite o envio de cookies de autenticação (se usados)
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'], // Permite todos os métodos HTTP comuns
  allowedHeaders: ['Content-Type', 'Authorization'] // Permite os cabeçalhos necessários
}));
// --- FIM DA SEÇÃO DE CONFIGURAÇÃO DO CORS ---


// Servir arquivos estáticos (para imagens de imóveis, por exemplo)
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// Rotas da API
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/properties', propertyRoutes);
app.use('/api/property-images', propertyImageRoutes);
app.use('/api/clients', clientRoutes);
app.use('/api/leads', leadRoutes);

// Rota de teste simples
app.get('/', (req, res) => {
  res.send('API Imobiliária funcionando!');
});

// Iniciar o servidor
app.listen(PORT, () => {
  console.log(`Servidor backend rodando na porta ${PORT}`);
});
