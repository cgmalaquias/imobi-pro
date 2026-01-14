import { defineStore } from 'pinia';
import { api } from 'src/boot/axios';
import type { AxiosError } from 'axios';

export type PropertyType = 'CASA' | 'APARTAMENTO' | 'TERRENO' | 'COMERCIAL' | 'RURAL';
export type PropertyStatus = 'DISPONIVEL' | 'RESERVADO' | 'VENDIDO' | 'ALUGADO' | 'INATIVO';
export type TransactionType = 'VENDA' | 'ALUGUEL' | 'AMBOS';

export interface PropertyImage {
  id: string;
  propertyId: string;
  url: string;
  order: number;
  createdAt: string;
}

export interface Property {
  id: string;
  title: string;
  description?: string;
  type: PropertyType;
  transactionType: TransactionType;
  status: PropertyStatus;
  priceSale?: number;
  priceRent?: number;
  address: string;
  neighborhood: string;
  city: string;
  state: string;
  zipCode?: string;
  areaTotal?: number;
  areaBuilt?: number;
  bedrooms?: number;
  bathrooms?: number;
  garage?: number;
  featured: boolean;
  userId: string;
  createdAt: string;
  updatedAt: string;
  images?: PropertyImage[];
  user?: {
    id: string;
    name: string;
  };
}

export interface PropertyFilters {
  page?: number;
  limit?: number;
  type?: PropertyType;
  city?: string;
  status?: PropertyStatus;
  featured?: boolean;
}

export interface PropertyResponse {
  properties: Property[];
  total: number;
  page: number;
  totalPages: number;
}

interface ErrorResponse {
  message: string;
}

interface ImageUploadResponse {
  message: string;
  images: PropertyImage[];
}

export const usePropertyStore = defineStore('property', {
  state: () => ({
    properties: [] as Property[],
    currentProperty: null as Property | null,
    loading: false,
    error: null as string | null,
    total: 0,
    page: 1,
    totalPages: 0
  }),

  getters: {
    getPropertyById: (state) => (id: string) => {
      return state.properties.find((p) => p.id === id);
    },

    featuredProperties: (state) => {
      return state.properties.filter((p) => p.featured);
    },

    propertiesByType: (state) => (type: PropertyType) => {
      return state.properties.filter((p) => p.type === type);
    },

    propertiesByCity: (state) => (city: string) => {
      return state.properties.filter((p) =>
        p.city.toLowerCase().includes(city.toLowerCase())
      );
    },

    availableProperties: (state) => {
      return state.properties.filter((p) => p.status === 'DISPONIVEL');
    }
  },

  actions: {
    async fetchProperties(filters?: PropertyFilters): Promise<PropertyResponse> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.get<PropertyResponse>('/properties', { params: filters });

        this.properties = response.data.properties;
        this.total = response.data.total;
        this.page = response.data.page;
        this.totalPages = response.data.totalPages;

        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao buscar imóveis';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async fetchPropertyById(id: string): Promise<Property> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.get<Property>(`/properties/${id}`);
        this.currentProperty = response.data;
        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao buscar imóvel';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async createProperty(data: Partial<Property>): Promise<Property> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.post<Property>('/properties', data);
        this.properties.unshift(response.data);
        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao criar imóvel';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async updateProperty(id: string, data: Partial<Property>): Promise<Property> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.put<Property>(`/properties/${id}`, data);

        const index = this.properties.findIndex((p) => p.id === id);
        if (index !== -1) {
          this.properties[index] = response.data;
        }

        if (this.currentProperty?.id === id) {
          this.currentProperty = response.data;
        }

        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao atualizar imóvel';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async deleteProperty(id: string): Promise<void> {
      this.loading = true;
      this.error = null;

      try {
        await api.delete(`/properties/${id}`);

        this.properties = this.properties.filter((p) => p.id !== id);

        if (this.currentProperty?.id === id) {
          this.currentProperty = null;
        }
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao excluir imóvel';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async toggleFeatured(id: string): Promise<Property> {
      this.loading = true;
      this.error = null;

      try {
        const response = await api.patch<Property>(`/properties/${id}/featured`);

        const index = this.properties.findIndex((p) => p.id === id);
        if (index !== -1) {
          this.properties[index] = response.data;
        }

        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao atualizar destaque';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async uploadImages(propertyId: string, files: File[]): Promise<ImageUploadResponse> {
      this.loading = true;
      this.error = null;

      try {
        const formData = new FormData();
        files.forEach((file) => {
          formData.append('images', file);
        });

        const response = await api.post<ImageUploadResponse>(
          `/properties/${propertyId}/images`,
          formData,
          {
            headers: {
              'Content-Type': 'multipart/form-data'
            }
          }
        );

        return response.data;
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao fazer upload de imagens';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async deleteImage(imageId: string): Promise<void> {
      this.loading = true;
      this.error = null;

      try {
        await api.delete(`/properties/images/${imageId}`);
      } catch (err) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao excluir imagem';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    clearError(): void {
      this.error = null;
    },

    clearCurrentProperty(): void {
      this.currentProperty = null;
    }
  }
});
