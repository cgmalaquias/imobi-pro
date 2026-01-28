// FILE: frontend/src/services/property.service.ts
import { api } from 'src/boot/api';

export interface PropertyImage {
  id: string;
  url: string;
  filename: string;
  property_id: string;
  created_at: string;
  updated_at: string;
}

export interface Property {
  id: string;
  title: string;
  description: string;
  type: 'CASA' | 'APARTAMENTO' | 'COMERCIAL' | 'TERRENO' | 'FAZENDA';
  status: 'DISPONIVEL' | 'VENDIDO' | 'ALUGADO';
  price: number;
  area?: number;
  bedrooms?: number;
  bathrooms?: number;
  garages?: number;
  address: string;
  city: string;
  state: string;
  zip_code?: string;
  latitude?: number;
  longitude?: number;
  images?: PropertyImage[];
  features?: string[]; // Se você tiver um campo de características
  visits?: Visit[]; // Para a página de detalhes do imóvel no admin
  created_at: string;
  updated_at: string;
}

export interface PropertyFilters {
  type?: string;
  status?: string;
  city?: string;
  minPrice?: number;
  maxPrice?: number;
  minArea?: number;
  maxArea?: number;
  bedrooms?: number;
  search?: string;
  page?: number;
  limit?: number;
  featured?: boolean; // Para imóveis em destaque
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

export const propertyService = {
  async getAll(filters?: PropertyFilters): Promise<PaginatedResponse<Property>> {
    const params = new URLSearchParams();

    if (filters) {
      Object.entries(filters).forEach(([key, value]) => {
        if (value !== undefined && value !== null) {
          params.append(key, String(value));
        }
      });
    }

    const query = params.toString();
    return api.get(`/properties${query ? `?${query}` : ''}`);
  },

  async getById(id: string): Promise<Property> {
    return api.get(`/properties/${id}`);
  },

  async create(data: FormData): Promise<Property> {
    // Para Laravel, FormData com _method=PUT não funciona diretamente com PUT
    // A API Laravel espera POST para upload de arquivos, mesmo para updates,
    // usando um campo _method no FormData para simular PUT.
    // No nosso api.upload, já estamos usando POST, então está correto.
    return api.upload('/properties', data);
  },

  async update(id: string, data: FormData): Promise<Property> {
    // Adicionar _method=PUT para Laravel reconhecer como PUT via POST
    data.append('_method', 'PUT');
    return api.upload(`/properties/${id}`, data);
  },

  async delete(id: string): Promise<void> {
    return api.delete(`/properties/${id}`);
  },

  async deleteImage(propertyId: string, imageId: string): Promise<void> {
    // Supondo que você tenha uma rota para deletar imagens específicas
    // Ex: DELETE api/properties/{property}/images/{image}
    return api.delete(`/properties/${propertyId}/images/${imageId}`);
  }
};
