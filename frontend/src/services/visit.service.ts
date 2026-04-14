// frontend/src/services/visit.service.ts
import { api } from 'src/boot/api';

// Tipo reutilizável para o status (resolve o erro de TypeScript)
export type VisitStatus = 'PENDENTE' | 'CONFIRMADA' | 'CONCLUIDA' | 'CANCELADA';

export interface Visit {
  id: string;
  property_id: string;

  // Campos renomeados pela migration
  client_name: string;
  client_email: string;
  client_phone: string;
  preferred_date: string;  // 'YYYY-MM-DD'
  preferred_time: string;  // 'HH:MM'

  message?: string | null;
  status: VisitStatus;     // Usa o tipo reutilizável

  // Campos adicionados pela migration
  user_id?: string | null;
  internal_notes?: string | null;

  created_at: string;
  updated_at: string;

  // Relacionamentos (retornados pelo backend com with())
  property?: {
    id: string;
    title: string;
    city?: string;
    state?: string;
    address?: string;
    neighborhood?: string;
    price?: number;
    type?: string;
    images?: { id: string; url: string }[];
  };
  user?: {
    id: string;
    name: string;
    email: string;
  } | null;
}

export interface PaginatedResponse<T> {
  data: T[];
  current_page: number;
  last_page: number;
  per_page: number;
  total: number;
}

export interface CreateVisitData {
  property_id: string;
  client_name: string;
  client_email: string;
  client_phone: string;
  preferred_date: string;  // 'YYYY-MM-DD'
  preferred_time: string;  // 'HH:MM'
  message?: string | null;
}

export interface UpdateVisitData {
  status: VisitStatus;           // Usa o tipo reutilizável
  user_id?: string | null;       // Para atribuir corretor
  internal_notes?: string | null; // Para anotações internas
}

export const visitService = {

  async create(data: CreateVisitData): Promise<Visit> {
    const response = await api.post('/visits', data);
    return response.data;
  },

  async getAll(
    status?: string,
    search?: string,
    page: number = 1,
    perPage: number = 10,
    sortBy: string = 'preferred_date',
    sortOrder: 'asc' | 'desc' = 'desc',
  ): Promise<PaginatedResponse<Visit>> {
    const queryParams = new URLSearchParams();

    if (status) queryParams.append('status', status);
    if (search) queryParams.append('search', search);

    queryParams.append('page', String(page));
    queryParams.append('per_page', String(perPage));
    queryParams.append('sort_by', sortBy);
    queryParams.append('sort_order', sortOrder);

    const response = await api.get(`/visits?${queryParams.toString()}`);
    return response;
  },

  async getById(id: string): Promise<Visit> {
    const response = await api.get(`/visits/${id}`);
    return response;
  },

  async update(id: string, data: UpdateVisitData): Promise<Visit> {
    const response = await api.put(`/visits/${id}`, data);
    return response;
  },

  async delete(id: string): Promise<void> {
    await api.delete(`/visits/${id}`);
  },
};
