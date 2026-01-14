import api from './api';
import type { AuthResponse, User } from '@types/index';

export class AuthService {
  static async register(name: string, email: string, password: string, phone?: string): Promise<AuthResponse> {
    const response = await api.post<AuthResponse>('/auth/register', {
      name,
      email,
      password,
      phone
    });
    return response.data;
  }

  static async login(email: string, password: string): Promise<AuthResponse> {
    const response = await api.post<AuthResponse>('/auth/login', {
      email,
      password
    });
    return response.data;
  }

  static async getMe(): Promise<{ user: User }> {
    const response = await api.get<{ user: User }>('/auth/me');
    return response.data;
  }
}
