import { defineStore } from 'pinia';
import { api } from 'src/boot/api';
import type { AxiosError } from 'axios';

export interface Lead {
  id: string;
  clientId: string;
  propertyId: string;
  userId: string;
  status: string;
  stage: string;
  probability: number;
  estimatedValue?: number;
  nextAction?: string;
  nextActionDate?: string;
  notes?: string;
  createdAt: string;
  updatedAt: string;
}

export interface LeadFilters {
  page?: number;
  limit?: number;
  status?: string;
  stage?: string;
  userId?: string;
}

export interface LeadResponse {
  leads: Lead[];
  total: number;
  page: number;
  totalPages: number;
}

interface ErrorResponse {
  message: string;
}

export const useLeadStore = defineStore('lead', {
  state: () => ({
    leads: [] as Lead[],
    loading: false,
    error: null as string | null,
    total: 0,
    page: 1,
    totalPages: 0
  }),

  getters: {
    getLeadById: (state) => (id: string) => {
      return state.leads.find((lead) => lead.id === id);
    },

    leadsByStatus: (state) => (status: string) => {
      return state.leads.filter((lead) => lead.status === status);
    },

    leadsByStage: (state) => (stage: string) => {
      return state.leads.filter((lead) => lead.stage === stage);
    }
  },

  actions: {
    async fetchLeads(filters?: LeadFilters): Promise<LeadResponse> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.get<LeadResponse>('/leads', { params: filters });

        this.leads = response.data.leads || [];
        this.total = response.data.total || 0;
        this.page = response.data.page || 1;
        this.totalPages = response.data.totalPages || 0;

        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao buscar leads';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async fetchLeadById(id: string): Promise<Lead> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.get<Lead>(`/leads/${id}`);
        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao buscar lead';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async createLead(data: Partial<Lead>): Promise<Lead> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.post<Lead>('/leads', data);
        this.leads.unshift(response.data);
        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao criar lead';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async updateLeadStatus(id: string, data: Partial<Lead>): Promise<Lead> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.put<Lead>(`/leads/${id}/status`, data);

        const index = this.leads.findIndex((lead) => lead.id === id);
        if (index !== -1) {
          this.leads[index] = response.data;
        }

        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao atualizar lead';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    clearError(): void {
      this.error = null;
    }
  }
});
