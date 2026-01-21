// frontend/src/stores/auth.ts
import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import { Notify } from 'quasar';

interface User {
  id: string;
  name: string;
  email: string;
  phone?: string;
  role: string;
  active: boolean;
  createdAt: string;
  updatedAt: string;
}

interface AuthResponse {
  message: string;
  user: User;
  token: string;
}

interface ErrorResponse {
  message: string;
}

export const useAuthStore = defineStore('auth', () => {
  const router = useRouter();
  const token = ref<string | null>(localStorage.getItem('token'));
  const user = ref<User | null>(JSON.parse(localStorage.getItem('user') || 'null'));
  const loading = ref<boolean>(false);

  const API_BASE_URL: string = process.env.API_URL || 'http://localhost:3000/api';

  const setAuthData = (newToken: string, newUser: User): void => {
    token.value = newToken;
    user.value = newUser;
    localStorage.setItem('token', newToken);
    localStorage.setItem('user', JSON.stringify(newUser));
  };

  const clearAuthData = (): void => {
    token.value = null;
    user.value = null;
    localStorage.removeItem('token');
    localStorage.removeItem('user');
  };

  const userName = computed<string>(() => user.value?.name || 'Convidado');
  const userEmail = computed<string>(() => user.value?.email || 'N/A');
  const isAdmin = computed<boolean>(() => user.value?.role === 'ADMIN');

  const login = async (email: string, password: string): Promise<boolean> => {
    loading.value = true;
    try {
      const response: Response = await fetch(`${API_BASE_URL}/auth/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
      });

      const data: AuthResponse | ErrorResponse = await response.json();

      if (response.ok) {
        const authData = data as AuthResponse;
        setAuthData(authData.token, authData.user);
        Notify.create({
          type: 'positive',
          message: authData.message || 'Login bem-sucedido!',
          position: 'top-right',
        });
        return true;
      } else {
        const errorData = data as ErrorResponse;
        Notify.create({
          type: 'negative',
          message: errorData.message || 'Erro ao fazer login.',
          position: 'top-right',
        });
        return false;
      }
    } catch (error: unknown) { // Usar unknown para erro de catch
      console.error('❌ Erro no login:', error);
      Notify.create({
        type: 'negative',
        message: (error as Error).message || 'Erro de rede ou na requisição.',
        position: 'top-right',
      });
      return false;
    } finally {
      loading.value = false;
    }
  };

  const register = async (name: string, email: string, password: string, phone?: string): Promise<boolean> => {
    loading.value = true;
    try {
      const response: Response = await fetch(`${API_BASE_URL}/auth/register`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ name, email, password, phone }),
      });

      const data: AuthResponse | ErrorResponse = await response.json();

      if (response.ok) {
        const authData = data as AuthResponse;
        setAuthData(authData.token, authData.user);
        Notify.create({
          type: 'positive',
          message: authData.message || 'Registro bem-sucedido!',
          position: 'top-right',
        });
        return true;
      } else {
        const errorData = data as ErrorResponse;
        Notify.create({
          type: 'negative',
          message: errorData.message || 'Erro ao registrar.',
          position: 'top-right',
        });
        return false;
      }
    } catch (error: unknown) {
      console.error('❌ Erro no registro:', error);
      Notify.create({
        type: 'negative',
        message: (error as Error).message || 'Erro de rede ou na requisição.',
        position: 'top-right',
      });
      return false;
    } finally {
      loading.value = false;
    }
  };

  const getMe = async (): Promise<User | null> => {
    loading.value = true;
    try {
      if (!token.value) {
        loading.value = false; // Garantir que loading seja false se não houver token
        return null;
      }

      const response: Response = await fetch(`${API_BASE_URL}/auth/me`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token.value}`,
        },
      });

      const data: { user: User } | ErrorResponse = await response.json();

      if (response.ok) {
        const userData = data as { user: User };
        user.value = userData.user;
        localStorage.setItem('user', JSON.stringify(userData.user));
        return userData.user;
      } else {
        const errorData = data as ErrorResponse;
        console.error('Erro ao buscar dados do usuário:', errorData.message);
        clearAuthData();
        await router.push('/login');
        return null;
      }
    } catch (error: unknown) {
      console.error('Erro de rede ao buscar dados do usuário:', error);
      clearAuthData();
      await router.push('/login');
      return null;
    } finally {
      loading.value = false;
    }
  };

  const logout = async (): Promise<void> => { // Adicionado Promise<void>
    clearAuthData();
    Notify.create({
      type: 'info',
      message: 'Você foi desconectado.',
      position: 'top-right',
    });
    await router.push('/login');
  };

  return {
    token,
    user,
    loading,
    login,
    register,
    userName,
    userEmail,
    isAdmin,
    getMe,
    logout,
  };
});
