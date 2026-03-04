// frontend/src/services/visit.service.ts
import { api } from 'src/boot/api';

export interface Visit {
  id: string;
  property_id: string;
  name: string;
  email: string;
  phone: string;
  date: string;   // 'YYYY-MM-DD'
  time: string;   // 'HH:MM'
  message?: string;
  status: 'PENDENTE' | 'CONFIRMADA' | 'CONCLUIDA' | 'CANCELADA';
  created_at: string;
  updated_at: string;
  // se o backend estiver retornando o imóvel relacionado:
  property?: {
    id: string;
    title: string;
    city?: string;
    state?: string;
  };
}

export interface PaginatedResponse<T> {
  data: T[];
  current_page: number;
  last_page: number;
  per_page: number;
  total: number;
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

export const visitService = {
  async create(data: CreateVisitData): Promise<Visit> {
    const response = await api.post('/visits', data);
    return response.data;
  },

  async getAll(params?: { status?: string; search?: string; page?: number; per_page?: number }):
    Promise<PaginatedResponse<Visit>>
  {
    const queryParams = new URLSearchParams();
    if (params?.status && params.status !== 'TODOS') queryParams.append('status', params.status);
    if (params?.search) queryParams.append('search', params.search);
    if (params?.page) queryParams.append('page', String(params.page));
    if (params?.per_page) queryParams.append('per_page', String(params.per_page));

    const response = await api.get(`/visits?${queryParams.toString()}`);
    return response.data;
  },

  async getById(id: string): Promise<Visit> {
    const response = await api.get(`/visits/${id}`);
    return response.data;
  },

  async update(id: string, data: UpdateVisitData): Promise<Visit> {
    const response = await api.put(`/visits/${id}`, data);
    return response.data;
  },
};
