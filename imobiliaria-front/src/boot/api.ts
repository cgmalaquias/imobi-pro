// FILE: frontend/src/boot/api.ts
import { boot } from 'quasar/wrappers';
import { LoadingBar, Notify } from 'quasar'; // Importar Notify também para erros globais

// URL base da API Laravel
export const API_BASE_URL = 'https://imobiproapi.agenciareinodigital.com.br/api';

// Helper para fazer requisições
export const api = {
  async request(endpoint: string, options: RequestInit = {}) {
    LoadingBar.start(); // Iniciar LoadingBar em cada requisição

    const token = localStorage.getItem('token');

    const headers: HeadersInit = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...options.headers,
    };

    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }

    try {
      const response = await fetch(`${API_BASE_URL}${endpoint}`, {
        ...options,
        headers,
      });

      if (!response.ok) {
        let errorMessage = 'Erro desconhecido na requisição.';
        try {
          const errorData = await response.json();
          errorMessage = errorData.message || JSON.stringify(errorData);
        } catch (jsonError) {
          errorMessage = `Erro ${response.status}: ${response.statusText}`;
        }

        Notify.create({
          type: 'negative',
          message: errorMessage,
          position: 'top',
          timeout: 5000,
        });
        throw new Error(errorMessage);
      }

      return response.json();
    } catch (error: any) {
      // Erros de rede ou outros erros antes da resposta do servidor
      if (!error.message.includes('Erro desconhecido')) { // Evitar duplicidade com o Notify acima
        Notify.create({
          type: 'negative',
          message: error.message || 'Erro de rede. Verifique sua conexão.',
          position: 'top',
          timeout: 5000,
        });
      }
      throw error; // Re-lançar o erro para ser tratado no componente/serviço chamador
    } finally {
      LoadingBar.stop(); // Parar LoadingBar no sucesso ou erro
    }
  },

  async get(endpoint: string) {
    return this.request(endpoint, { method: 'GET' });
  },

  async post(endpoint: string, data: any) {
    return this.request(endpoint, {
      method: 'POST',
      body: JSON.stringify(data),
    });
  },

  async put(endpoint: string, data: any) {
    return this.request(endpoint, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  },

  async delete(endpoint: string) {
    return this.request(endpoint, { method: 'DELETE' });
  },

  // Upload de arquivos (FormData)
  async upload(endpoint: string, formData: FormData) {
    LoadingBar.start(); // Iniciar LoadingBar

    const token = localStorage.getItem('token');

    const headers: HeadersInit = {
      'Accept': 'application/json',
      // Não definir 'Content-Type' para FormData, o navegador faz isso automaticamente
    };

    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }

    try {
      const response = await fetch(`${API_BASE_URL}${endpoint}`, {
        method: 'POST', // Laravel usa POST para upload, mesmo em PUT para _method
        headers,
        body: formData,
      });

      if (!response.ok) {
        let errorMessage = 'Erro desconhecido no upload.';
        try {
          const errorData = await response.json();
          errorMessage = errorData.message || JSON.stringify(errorData);
        } catch (jsonError) {
          errorMessage = `Erro ${response.status}: ${response.statusText}`;
        }
        Notify.create({
          type: 'negative',
          message: errorMessage,
          position: 'top',
          timeout: 5000,
        });
        throw new Error(errorMessage);
      }

      return response.json();
    } catch (error: any) {
      if (!error.message.includes('Erro desconhecido')) {
        Notify.create({
          type: 'negative',
          message: error.message || 'Erro de rede no upload. Verifique sua conexão.',
          position: 'top',
          timeout: 5000,
        });
      }
      throw error;
    } finally {
      LoadingBar.stop(); // Parar LoadingBar no sucesso ou erro
    }
  },
};

export default boot(() => {
  // Configurações opcionais para a LoadingBar
  LoadingBar.setDefaults({
    color: 'primary',
    size: '4px',
    position: 'top',
  });
});
