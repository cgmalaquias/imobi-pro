import { api } from 'src/boot/api';
import type { User } from './auth.service';
import type { PaginatedResponse } from './property.service';

export interface CreateUserData {
  name: string;
  email: string;
  password: string;
  role: 'ADMIN' | 'USUARIO';
  active?: boolean;
}

export interface UpdateUserData {
  name?: string;
  email?: string;
  password?: string;
  role?: 'ADMIN' | 'USUARIO';
  active?: boolean;
}

export const userService = {
  async getAll(): Promise<PaginatedResponse<User>> {
    return api.get('/users');
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
