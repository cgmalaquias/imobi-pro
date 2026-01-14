import api from './api';
import type { Lead, PaginatedResponse } from '@types/index';

export class LeadService {
  static async create(data: Partial<Lead>): Promise<{ message: string; lead: Lead }> {
    const response = await api.post('/leads', data);
    return response.data;
  }

  static async getAll(page: number = 1, limit: number = 10, filters?: any): Promise<PaginatedResponse<Lead>> {
    const response = await api.get('/leads', {
      params: { page, limit, ...filters }
    });
    return response.data;
  }

  static async getById(id: string): Promise<{ lead: Lead }> {
    const response = await api.get(`/leads/${id}`);
    return response.data;
  }

  static async updateStatus(id: string, data: any): Promise<{ message: string; lead: Lead }> {
    const response = await api.patch(`/leads/${id}/status`, data);
    return response.data;
  }

  static async scheduleVisit(id: string, scheduledVisit: string, nextAction?: string): Promise<{ message: string; lead: Lead }> {
    const response = await api.post(`/leads/${id}/schedule-visit`, {
      scheduled_visit: scheduledVisit,
      next_action: nextAction
    });
    return response.data;
  }

  static async addNote(id: string, note: string): Promise<{ message: string; lead: Lead }> {
    const response = await api.post(`/leads/${id}/notes`, { note });
    return response.data;
  }

  static async getMetrics(): Promise<{ metrics: any }> {
    const response = await api.get('/leads/metrics/dashboard');
    return response.data;
  }
}
