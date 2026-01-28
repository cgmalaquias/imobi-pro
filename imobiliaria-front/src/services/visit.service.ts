// FILE: frontend/src/services/visit.service.ts
import { api } from 'src/boot/api';
import type { Property } from './property.service'; // Importar Property para tipagem

export interface Visit {
  id: string;
  property_id: string;
  property?: Property; // Opcional, se a API retornar o imóvel junto
  name: string;
  email: string;
  phone: string;
  date: string; // Formato 'YYYY-MM-DD'
  time: string; // Formato 'HH:MM'
  message?: string;
  status: 'PENDENTE' | 'CONFIRMADA' | 'CONCLUIDA' | 'CANCELADA';
  created_at: string;
  updated_at: string;
}

export interface CreateVisitData {
  property_id: string;
  name: string;
  email: string;
  phone: string;
  date: string;
  time: string;
  message?: string;
}

export interface UpdateVisitData {
  status: 'PENDENTE' | 'CONFIRMADA' | 'CONCLUIDA' | 'CANCELADA';
}

export interface VisitFilters {
  status?: string;
  search?: string; // Para buscar por nome, email, etc.
  page?: number;
  limit?: number;
}

export interface PaginatedResponse<T> {
  data: T[];
  current_page: number;
  first_page_url: string;
  from: number;
  last_page: number;
  last_page_url: string;
  links: { url: string | null; label: string; active: boolean }[];
  next_page_url: string | null;
  path: string;
  per_page: number;
  prev_page_url: string | null;
  to: number;
  total: number;
}

export const visitService = {
  async getAll(filters?: VisitFilters): Promise<PaginatedResponse<Visit>> {
    const params = new URLSearchParams();

    if (filters) {
      Object.entries(filters).forEach(([key, value]) => {
        if (value !== undefined && value !== null) {
          params.append(key, String(value));
        }
      });
    }

    const query = params.toString();
    return api.get(`/visits${query ? `?${query}` : ''}`);
  },

  async getById(id: string): Promise<Visit> {
    return api.get(`/visits/${id}`);
  },

  async create(data: CreateVisitData): Promise<Visit> {
    return api.post('/visits', data);
  },

  async update(id: string, data: UpdateVisitData): Promise<Visit> {
    return api.put(`/visits/${id}`, data);
  },

  async delete(id: string): Promise<void> {
    return api.delete(`/visits/${id}`);
  },
};
