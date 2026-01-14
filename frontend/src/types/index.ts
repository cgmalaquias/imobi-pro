export enum UserRole {
  ADMIN = 'admin',
  CORRETOR = 'corretor',
  GERENTE = 'gerente'
}

export enum PropertyType {
  CASA = 'casa',
  APARTAMENTO = 'apartamento',
  TERRENO = 'terreno',
  COMERCIAL = 'comercial',
  RURAL = 'rural'
}

export enum TransactionType {
  VENDA = 'venda',
  ALUGUEL = 'aluguel',
  AMBOS = 'ambos'
}

export enum PropertyStatus {
  DISPONIVEL = 'disponivel',
  RESERVADO = 'reservado',
  VENDIDO = 'vendido',
  ALUGADO = 'alugado',
  INATIVO = 'inativo'
}

export enum LeadStatus {
  NOVO = 'novo',
  CONTATADO = 'contatado',
  VISITOU = 'visitou',
  INTERESSADO = 'interessado',
  NEGOCIANDO = 'negociando',
  PERDIDO = 'perdido',
  CONCLUIDO = 'concluido'
}

export interface User {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  phone?: string;
  avatar?: string;
  active: boolean;
}

export interface Property {
  id: string;
  title: string;
  description: string;
  type: PropertyType;
  transaction_type: TransactionType;
  price_sale?: number;
  price_rent?: number;
  area: number;
  bedrooms: number;
  bathrooms: number;
  garage: number;
  address: string;
  neighborhood: string;
  city: string;
  state: string;
  zip_code?: string;
  latitude?: number;
  longitude?: number;
  features: string[];
  status: PropertyStatus;
  featured: boolean;
  views: number;
  user_id: string;
  images?: PropertyImage[];
  user?: User;
  createdAt?: string;
  updatedAt?: string;
}

export interface PropertyImage {
  id: string;
  property_id: string;
  url: string;
  is_cover: boolean;
  order: number;
}

export interface Client {
  id: string;
  name: string;
  email: string;
  phone: string;
  cpf?: string;
  date_birth?: string;
  address?: string;
  neighborhood?: string;
  city?: string;
  state?: string;
  zip_code?: string;
  source: 'site' | 'indicacao' | 'anuncio' | 'outro';
  notes?: string;
  active: boolean;
  leads?: Lead[];
  createdAt?: string;
  updatedAt?: string;
}

export interface Lead {
  id: string;
  client_id: string;
  property_id: string;
  user_id: string;
  status: LeadStatus;
  stage: 'prospeccao' | 'qualificacao' | 'apresentacao' | 'negociacao' | 'fechamento';
  next_action?: string;
  next_action_date?: string;
  notes?: string;
  probability: number;
  client?: Client;
  property?: Property;
  user?: User;
  history?: LeadHistory[];
  createdAt?: string;
  updatedAt?: string;
}

export interface LeadHistory {
  id: string;
  lead_id: string;
  action: string;
  description?: string;
  old_value?: string;
  new_value?: string;
  user_id: string;
  createdAt?: string;
}

export interface AuthResponse {
  message: string;
  user: User;
  token: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  pagination: {
    total: number;
    page: number;
    limit: number;
    pages: number;
  };
}
