import { boot } from 'quasar/wrappers';
import { LoadingBar } from 'quasar'; // Importar LoadingBar

// URL base da API Laravel
// VERIFIQUE SE ESTA URL ESTÁ CORRETA E SEMPRE ATUALIZADA
// export const API_BASE_URL = 'https://imobiproapi.agenciareinodigital.com.br/api';
export const API_BASE_URL = 'http://corretora-backend.ls/api';

// Helper para fazer requisições
export const api = {
  async request(endpoint: string, options: RequestInit = {}) {
    LoadingBar.start(); // Iniciar LoadingBar

    const token = localStorage.getItem('token');

    // CORREÇÃO AQUI: Declarar headers como Record<string, string>
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // Espalhar outros headers, se existirem, garantindo que sejam strings
      ...(options.headers as Record<string, string> || {}), // Cast para Record<string, string>
    };

    if (token) {
      headers['Authorization'] = `Bearer ${token}`; // Agora TypeScript aceita
    }

    try {
      const response = await fetch(`${API_BASE_URL}${endpoint}`, {
        ...options,
        headers,
      });

      if (!response.ok) {
        const error = await response.json().catch(() => ({ message: 'Erro na requisição' }));
        throw new Error(error.message || 'Erro na requisição');
      }

      return response.json();
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
    };

    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }

    try {
      const response = await fetch(`${API_BASE_URL}${endpoint}`, {
        method: 'POST',
        headers,
        body: formData,
      });

      if (!response.ok) {
        const error = await response.json().catch(() => ({ message: 'Erro no upload' }));
        throw new Error(error.message || 'Erro no upload');
      }

      return response.json();
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
