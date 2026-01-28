import { api } from 'src/boot/api';

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
  features?: PropertyFeature[];
  visits?: Visit[];
  created_at: string;
  updated_at: string;
}

export interface PropertyImage {
  id: string;
  property_id: string;
  url: string;
  order: number;
}

export interface PropertyFeature {
  id: string;
  property_id: string;
  name: string;
}

export interface Visit {
  id: string;
  property_id: string;
  name: string;
  email: string;
  phone: string;
  date: string;
  time: string;
  message?: string;
  status: 'PENDENTE' | 'CONFIRMADA' | 'CONCLUIDA' | 'CANCELADA';
  created_at: string;
  updated_at: string;
}

export interface PropertyFilters {
  type?: string;
  status?: string;
  city?: string;
  minPrice?: number;
  maxPrice?: number;
  search?: string;
  page?: number;
}

export interface PaginatedResponse<T> {
  data: T[];
  current_page: number;
  last_page: number;
  per_page: number;
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
    return api.upload('/properties', data);
  },

  async update(id: string, data: FormData): Promise<Property> {
    // Laravel não suporta PUT com FormData, usar POST com _method
    data.append('_method', 'PUT');
    return api.upload(`/properties/${id}`, data);
  },

  async delete(id: string): Promise<void> {
    return api.delete(`/properties/${id}`);
  },
};
