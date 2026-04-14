import { api } from 'src/boot/api';

export type PropertyType =
  | 'CASA'
  | 'APARTAMENTO'
  | 'COMERCIAL'
  | 'TERRENO'
  | 'FAZENDA';
export type TransactionType = 'VENDA' | 'ALUGUEL' | 'TROCA' | 'A COMBINAR';
export type PropertyStatus = 'DISPONIVEL' | 'VENDIDO' | 'ALUGADO';

export interface PropertyImage {
  id: string;
  path: string;
  url?: string; // Opcional, pois você constrói no frontend
}

export interface PropertyFeature {
  id: string;
  name: string;
}
export interface Property {
  id: string;
  slug?: string;
  title: string;
  description: string;
  type: PropertyType;
  status: PropertyStatus;
  transaction_type: TransactionType; // ✅ Adicione ou confirme esta linha
  price: number;
  area?: number;
  bedrooms?: number;
  bathrooms?: number;
  suites?: number;
  parking_spaces?: number;
  address?: string;
  neighborhood?: string;
  city: string;
  state: string;
  zip_code?: string;
  featured?: boolean;
  created_at?: string;
  updated_at?: string;
  images?: PropertyImage[];
  features?: PropertyFeature[];
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
  slug: string;
  client_name: string;
  client_email: string;
  client_phone: string;
  date: string;
  time: string;
  message?: string;
  status: 'PENDENTE' | 'CONFIRMADA' | 'CONCLUIDA' | 'CANCELADA';
  created_at: string;
  updated_at: string;
}

export interface PropertyFilters {
  page?: number;
  limit?: number;
  type?: PropertyType;
  city?: string;
  status?: PropertyStatus;
  featured?: boolean;
  transactionType?: TransactionType; // ✅ Este é o filtro, mas a propriedade do imóvel é transaction_type
  search?: string;
  minPrice?: number;
  maxPrice?: number;
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

  async getBySlug(slug: string): Promise<Property> {
    return api.get(`/properties/slug/${slug}`);
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
