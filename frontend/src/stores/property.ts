// FILE: frontend/src/services/property.service.ts
import { api } from 'src/boot/api'; // Importar o helper 'api'

// Interfaces (já definidas anteriormente)
export type PropertyType = 'CASA' | 'APARTAMENTO' | 'COMERCIAL' | 'TERRENO' | 'FAZENDA';
export type PropertyStatus = 'DISPONIVEL' | 'VENDIDO' | 'ALUGADO';

export interface PropertyImage {
  id: string;
  url: string;
  property_id: string;
  created_at: string;
  updated_at: string;
}

export interface Property {
  id: string;
  title: string;
  description: string;
  price: number;
  type: PropertyType;
  address: string;
  city: string;
  state: string;
  zip_code?: string;
  bedrooms?: number;
  bathrooms?: number;
  area?: number;
  status: PropertyStatus;
  created_at: string;
  updated_at: string;
  images: PropertyImage[]; // Relação com imagens
}

export interface PropertyFilters {
  page?: number;
  limit?: number;
  status?: PropertyStatus;
  type?: PropertyType;
  city?: string;
  minPrice?: number;
  maxPrice?: number;
}

// Interface para a resposta paginada da API Laravel
export interface PaginatedResponse<T> {
  data: T[];
  current_page: number;
  first_page_url: string;
  from: number;
  last_page: number;
  links: { url: string | null; label: string; active: boolean }[];
  next_page_url: string | null;
  path: string;
  per_page: number;
  prev_page_url: string | null;
  to: number;
  total: number;
}

export const propertyService = {
  async getAll(params?: PropertyFilters): Promise<PaginatedResponse<Property>> {
    const query = new URLSearchParams();
    if (params) {
      Object.entries(params).forEach(([k, v]) => {
        if (v !== undefined && v !== null && v !== '') {
          query.append(k, String(v));
        }
      });
    }
    const qs = query.toString();
    // Usando o helper 'api' para fazer a requisição GET
    return api.get(`/properties${qs ? `?${qs}` : ''}`);
  },

  async getById(id: string): Promise<Property> {
    // Usando o helper 'api' para fazer a requisição GET
    return api.get(`/properties/${id}`);
  },

  async create(payload: FormData): Promise<Property> {
    // Usando o helper 'api.upload' para FormData
    return api.upload('/properties', payload);
  },

  async update(id: string, payload: FormData): Promise<Property> {
    // Usando o helper 'api.upload' para FormData (Laravel espera PUT/POST para FormData)
    // Nota: Para PUT com FormData, o Laravel pode precisar de um campo _method=PUT
    payload.append('_method', 'PUT');
    return api.upload(`/properties/${id}`, payload);
  },

  async delete(id: string): Promise<void> {
    // Usando o helper 'api' para fazer a requisição DELETE
    return api.delete(`/properties/${id}`);
  },

  async deleteImage(propertyId: string, imageId: string): Promise<{ message: string }> {
    // Usando o helper 'api' para fazer a requisição DELETE
    return api.delete(`/properties/${propertyId}/images/${imageId}`);
  },
};
