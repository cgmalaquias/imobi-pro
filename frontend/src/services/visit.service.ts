import { api } from 'src/boot/api';
import type { Visit, PaginatedResponse } from './property.service';

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
    return api.post('/visits', data);
  },

  async getAll(status?: string): Promise<PaginatedResponse<Visit>> {
    const query = status ? `?status=${status}` : '';
    return api.get(`/visits${query}`);
  },

  async update(id: string, data: UpdateVisitData): Promise<Visit> {
    return api.put(`/visits/${id}`, data);
  },
};
