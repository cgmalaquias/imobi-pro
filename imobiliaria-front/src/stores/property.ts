import { defineStore } from 'pinia';
import { api } from 'src/boot/api';
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
  search?: string; // Adicionado search para consistência
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
    loading: false as boolean,
    error: null as string | null,
    total: 0 as number,
    page: 1 as number,
    totalPages: 0 as number
  }),

  getters: {
    getPropertyById: (state) => (id: string): Property | undefined => {
      return state.properties.find((p) => p.id === id);
    },

    featuredProperties: (state): Property[] => {
      return state.properties.filter((p) => p.featured);
    },

    propertiesByType: (state) => (type: PropertyType): Property[] => {
      return state.properties.filter((p) => p.type === type);
    },

    propertiesByCity: (state) => (city: string): Property[] => {
      return state.properties.filter((p) =>
        p.city.toLowerCase().includes(city.toLowerCase())
      );
    },

    availableProperties: (state): Property[] => {
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
      } catch (err: unknown) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao buscar imóveis';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async fetchPropertyById(id: string): Promise<Property | null> {
      this.loading = true;
      this.error = null;
      try {
        const response = await api.get<Property>(`/properties/${id}`);
        this.currentProperty = response.data;
        return response.data;
      } catch (err: unknown) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao buscar imóvel';
        this.currentProperty = null;
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async createProperty(propertyData: FormData): Promise<Property> { // <-- Alterado para FormData
      this.loading = true;
      this.error = null;
      try {
        const response = await api.post<Property>('/properties', propertyData, { // <-- Adicionado headers para FormData
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        });
        this.properties.push(response.data);
        return response.data;
      } catch (err: unknown) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao criar imóvel';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async updateProperty(id: string, propertyData: Partial<Property>): Promise<Property> {
      this.loading = true;
      this.error = null;
      try {
        const response = await api.put<Property>(`/properties/${id}`, propertyData);
        const index = this.properties.findIndex((p) => p.id === id);
        if (index !== -1) {
          this.properties[index] = response.data;
        }
        this.currentProperty = response.data; // Atualiza o currentProperty também
        return response.data;
      } catch (err: unknown) {
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
      } catch (err: unknown) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao excluir imóvel';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async toggleFeatured(id: string): Promise<void> {
      this.loading = true;
      this.error = null;
      try {
        const response = await api.patch<Property>(`/properties/${id}/featured`);
        const index = this.properties.findIndex((p) => p.id === id);
        if (index !== -1) {
          this.properties[index].featured = response.data.featured;
        }
        if (this.currentProperty?.id === id) {
          this.currentProperty.featured = response.data.featured;
        }
      } catch (err: unknown) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao atualizar destaque';
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async uploadImages(propertyId: string, files: File[]): Promise<PropertyImage[]> {
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
              'Content-Type': 'multipart/form-data',
            },
          }
        );
        // Atualiza as imagens do imóvel atual no store, se ele estiver carregado
        if (this.currentProperty && this.currentProperty.id === propertyId) {
          this.currentProperty.images = [...(this.currentProperty.images || []), ...response.data.images];
        }
        return response.data.images;
      } catch (err: unknown) {
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
        // Remove a imagem do imóvel atual no store, se ele estiver carregado
        if (this.currentProperty?.images) {
          this.currentProperty.images = this.currentProperty.images.filter(img => img.id !== imageId);
        }
      } catch (err: unknown) {
        const error = err as AxiosError<ErrorResponse>;
        this.error = error.response?.data?.message || 'Erro ao deletar imagem';
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
