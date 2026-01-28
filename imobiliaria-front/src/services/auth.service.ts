// FILE: frontend/src/services/auth.service.ts
import { api } from 'src/boot/api';

export interface LoginCredentials {
  email: string;
  password: string;
}

export interface RegisterData {
  name: string;
  email: string;
  password: string;
  password_confirmation: string;
}

export interface User {
  id: string;
  name: string;
  email: string;
  role: 'ADMIN' | 'USUARIO';
  active: boolean;
}

export interface AuthResponse {
  message: string;
  user: User;
  token: string;
}

export const authService = {
  async login(credentials: LoginCredentials): Promise<AuthResponse> {
    const response = await api.post('/auth/login', credentials);

    // Salvar token e usuário no localStorage
    localStorage.setItem('token', response.token);
    localStorage.setItem('user', JSON.stringify(response.user));

    return response;
  },

  async register(data: RegisterData): Promise<AuthResponse> {
    const response = await api.post('/auth/register', data);

    // Salvar token e usuário no localStorage
    localStorage.setItem('token', response.token);
    localStorage.setItem('user', JSON.stringify(response.user));

    return response;
  },

  async logout(): Promise<void> {
    try {
      await api.post('/auth/logout', {});
    } catch (error) {
      console.error('Erro ao fazer logout:', error);
      // Não re-lançar, pois o objetivo é limpar o token local de qualquer forma
    } finally {
      localStorage.removeItem('token');
      localStorage.removeItem('user');
    }
  },

  async me(): Promise<User> {
    return api.get('/auth/me');
  },

  async refreshToken(): Promise<{ token: string }> {
    const response = await api.post('/auth/refresh', {});
    localStorage.setItem('token', response.token);
    return response;
  },

  getUser(): User | null {
    const userStr = localStorage.getItem('user');
    return userStr ? JSON.parse(userStr) : null;
  },

  getToken(): string | null {
    return localStorage.getItem('token');
  },

  isAuthenticated(): boolean {
    return !!this.getToken();
  },

  isAdmin(): boolean {
    const user = this.getUser();
    return user?.role === 'ADMIN';
  },
};
