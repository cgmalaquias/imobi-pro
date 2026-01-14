import { defineStore } from 'pinia';
import { api } from 'src/boot/axios';
import type { AxiosError } from 'axios';
import type { User } from './auth';

export interface UserFilters {
  page?: number;
  limit?: number;
  role?: 'ADMIN' | 'CORRETOR' | 'GERENTE';
  active?: boolean;
}

export interface UserResponse {
  users: User[];
  total: number;
  page: number;
  totalPages: number;
}

interface ErrorResponse {
  message: string;
}

export const useUserStore = defineStore('user', {
  state: () => ({
    users: [] as User[],
    currentUser: null as User | null,
    loading: false,
    error: null as string | null,
    total: 0,
    page: 1,
    totalPages: 0
  }),

  getters: {
    getUserById: (state) => (id: string) => {
      return state.users.find((user) => user.id === id);
    },

    activeUsers: (state) => {
      return state.users.filter((user) => user.active);
    },

    usersByRole: (state) => (role: 'ADMIN' | 'CORRETOR' | 'GERENTE') => {
      return state.users.filter((user) => user.role === role);
    },

    admins: (state) => {
      return state.users.filter((user) => user.role === 'ADMIN');
    },

    corretores: (state) => {
      return state.users.filter((user) => user.role === 'CORRETOR');
    }
  },

  actions: {
    async fetchUsers(filters?: UserFilters): Promise<UserResponse> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.get<UserResponse>('/users', { params: filters });

        this.users = response.data.users || [];
        this.total = response.data.total || 0;
        this.page = response.data.page || 1;
        this.totalPages = response.data.totalPages || 0;

        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao buscar usuários';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async fetchUserById(id: string): Promise<User> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.get<User>(`/users/${id}`);
        this.currentUser = response.data;
        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao buscar usuário';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async updateUser(id: string, data: Partial<User>): Promise<User> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.put<User>(`/users/${id}`, data);

        const index = this.users.findIndex((user) => user.id === id);
        if (index !== -1) {
          this.users[index] = response.data;
        }

        if (this.currentUser?.id === id) {
          this.currentUser = response.data;
        }

        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao atualizar usuário';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async deleteUser(id: string): Promise<void> {
      this.loading = true;
      this.error = null;

      try {
        await api.delete(`/users/${id}`);

        this.users = this.users.filter((user) => user.id !== id);

        if (this.currentUser?.id === id) {
          this.currentUser = null;
        }
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao excluir usuário';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    clearError(): void {
      this.error = null;
    },

    clearCurrentUser(): void {
      this.currentUser = null;
    }
  }
});
