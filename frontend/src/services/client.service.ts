import api from './api';
import type { Client, PaginatedResponse } from '@types/index';

export class ClientService {
  static async create(data: Partial<Client>): Promise<{ message: string; client: Client }> {
    const response = await api.post('/clients', data);
    return response.data;
  }

  static async getAll(page: number = 1, limit: number = 10, filters?: any): Promise<PaginatedResponse<Client>> {
    const response = await api.get('/clients', {
      params: { page, limit, ...filters }
    });
    return response.data;
  }

  static async getById(id: string): Promise<{ client: Client }> {
    const response = await api.get(`/clients/${id}`);
    return response.data;
  }

  static async update(id: string, data: Partial<Client>): Promise<{ message: string; client: Client }> {
    const response = await api.put(`/clients/${id}`, data);
    return response.data;
  }

  static async delete(id: string): Promise<{ message: string }> {
    const response = await api.delete(`/clients/${id}`);
    return response.data;
  }

  static async search(query: string): Promise<{ clients: Client[] }> {
    const response = await api.get('/clients/search/advanced', {
      params: { q: query }
    });
    return response.data;
  }
}
