import api from './api';
import type { Property, PropertyImage, PaginatedResponse } from '@types/index';

export class PropertyService {
  static async create(data: Partial<Property>): Promise<{ message: string; property: Property }> {
    const response = await api.post('/properties', data);
    return response.data;
  }

  static async getAll(page: number = 1, limit: number = 10, filters?: any): Promise<PaginatedResponse<Property>> {
    const response = await api.get('/properties', {
      params: { page, limit, ...filters }
    });
    return response.data;
  }

  static async getById(id: string): Promise<{ property: Property }> {
    const response = await api.get(`/properties/${id}`);
    return response.data;
  }

  static async update(id: string, data: Partial<Property>): Promise<{ message: string; property: Property }> {
    const response = await api.put(`/properties/${id}`, data);
    return response.data;
  }

  static async delete(id: string): Promise<{ message: string }> {
    const response = await api.delete(`/properties/${id}`);
    return response.data;
  }

  static async toggleFeatured(id: string): Promise<{ message: string; property: Property }> {
    const response = await api.patch(`/properties/${id}/featured`);
    return response.data;
  }

  static async search(query: string, filters?: any): Promise<{ properties: Property[] }> {
    const response = await api.get('/properties/search/advanced', {
      params: { q: query, ...filters }
    });
    return response.data;
  }

  static async uploadImages(propertyId: string, files: File[]): Promise<{ message: string; images: PropertyImage[] }> {
    const formData = new FormData();
    files.forEach(file => formData.append('images', file));

    const response = await api.post(`/properties/${propertyId}/images`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    });
    return response.data;
  }

  static async deleteImage(propertyId: string, imageId: string): Promise<{ message: string }> {
    const response = await api.delete(`/properties/${propertyId}/images/${imageId}`);
    return response.data;
  }

  static async reorderImages(propertyId: string, imageIds: string[]): Promise<{ message: string }> {
    const response = await api.put(`/properties/${propertyId}/images/reorder`, { images: imageIds });
    return response.data;
  }
}
