import { defineStore } from 'pinia';
import { api } from 'src/boot/api';
import type { AxiosError } from 'axios';

export interface Client {
  id: string;
  name: string;
  email?: string;
  phone: string;
  cpf?: string;
  dateBirth?: string;
  address?: string;
  neighborhood?: string;
  city?: string;
  state?: string;
  zipCode?: string;
  source: string;
  notes?: string;
  active: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface ClientFilters {
  page?: number;
  limit?: number;
  source?: string;
  active?: boolean;
  search?: string;
}

export interface ClientResponse {
  clients: Client[];
  total: number;
  page: number;
  totalPages: number;
}

interface ErrorResponse {
  message: string;
}

export const useClientStore = defineStore('client', {
  state: () => ({
    clients: [] as Client[],
    currentClient: null as Client | null,
    loading: false,
    error: null as string | null,
    total: 0,
    page: 1,
    totalPages: 0
  }),

  getters: {
    getClientById: (state) => (id: string) => {
      return state.clients.find((client) => client.id === id);
    },

    activeClients: (state) => {
      return state.clients.filter((client) => client.active);
    },

    clientsBySource: (state) => (source: string) => {
      return state.clients.filter((client) => client.source === source);
    }
  },

  actions: {
    async fetchClients(filters?: ClientFilters): Promise<ClientResponse> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.get<ClientResponse>('/clients', { params: filters });

        this.clients = response.data.clients || [];
        this.total = response.data.total || 0;
        this.page = response.data.page || 1;
        this.totalPages = response.data.totalPages || 0;

        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao buscar clientes';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async fetchClientById(id: string): Promise<Client> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.get<Client>(`/clients/${id}`);
        this.currentClient = response.data;
        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao buscar cliente';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async createClient(data: Partial<Client>): Promise<Client> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.post<Client>('/clients', data);
        this.clients.unshift(response.data);
        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao criar cliente';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async updateClient(id: string, data: Partial<Client>): Promise<Client> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.put<Client>(`/clients/${id}`, data);

        const index = this.clients.findIndex((client) => client.id === id);
        if (index !== -1) {
          this.clients[index] = response.data;
        }

        if (this.currentClient?.id === id) {
          this.currentClient = response.data;
        }

        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao atualizar cliente';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async deleteClient(id: string): Promise<void> {
      this.loading = true;
      this.error = null;

      try {
        await api.delete(`/clients/${id}`);

        this.clients = this.clients.filter((client) => client.id !== id);

        if (this.currentClient?.id === id) {
          this.currentClient = null;
        }
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao excluir cliente';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async searchClients(query: string): Promise<Client[]> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.get<Client[]>('/clients/search', {
          params: { q: query }
        });
        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao buscar clientes';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    clearError(): void {
      this.error = null;
    },

    clearCurrentClient(): void {
      this.currentClient = null;
    }
  }
});
