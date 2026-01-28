// FILE: frontend/src/services/user.service.ts
import { api } from 'src/boot/api';

export interface User {
  id: string;
  name: string;
  email: string;
  role: 'ADMIN' | 'USUARIO';
  active: boolean;
  created_at: string;
  updated_at: string;
}

export interface CreateUserData {
  name: string;
  email: string;
  password?: string; // Opcional para criação, mas pode ser necessário
  role: 'ADMIN' | 'USUARIO';
  active: boolean;
}

export interface UpdateUserData {
  name?: string;
  email?: string;
  password?: string;
  role?: 'ADMIN' | 'USUARIO';
  active?: boolean;
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

export const userService = {
  async getAll(filters?: { search?: string; page?: number; limit?: number }): Promise<PaginatedResponse<User>> {
    const params = new URLSearchParams();

    if (filters) {
      Object.entries(filters).forEach(([key, value]) => {
        if (value !== undefined && value !== null) {
          params.append(key, String(value));
        }
      });
    }

    const query = params.toString();
    return api.get(`/users${query ? `?${query}` : ''}`);
  },

  async getById(id: string): Promise<User> {
    return api.get(`/users/${id}`);
  },

  async create(data: CreateUserData): Promise<User> {
    return api.post('/users', data);
  },

  async update(id: string, data: UpdateUserData): Promise<User> {
    return api.put(`/users/${id}`, data);
  },

  async delete(id: string): Promise<void> {
    return api.delete(`/users/${id}`);
  },
};
