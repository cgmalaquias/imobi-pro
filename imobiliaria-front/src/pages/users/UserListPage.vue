<template>
  <div class="client-list-page">
    <div class="page-header">
      <h1>Clientes</h1>
      <button @click="openAddClientModal" class="btn btn-primary">
        + Novo Cliente
      </button>
    </div>

    <div class="filters">
      <input
        v-model="searchQuery"
        type="text"
        placeholder="Buscar clientes..."
        class="search-input"
      />
      <select v-model="statusFilter" class="status-filter">
        <option value="">Todos os status</option>
        <option value="active">Ativo</option>
        <option value="inactive">Inativo</option>
      </select>
    </div>

    <div v-if="loading" class="loading">
      <p>Carregando clientes...</p>
    </div>

    <div v-else-if="filteredClients.length > 0" class="clients-table">
      <table>
        <thead>
          <tr>
            <th>Nome</th>
            <th>Email</th>
            <th>Telefone</th>
            <th>Status</th>
            <th>Data de Cadastro</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="client in filteredClients" :key="client.id">
            <td>{{ client.name }}</td>
            <td>{{ client.email }}</td>
            <td>{{ client.phone }}</td>
            <td>
              <span :class="['status-badge', `status-${client.status}`]">
                {{ client.status === 'active' ? 'Ativo' : 'Inativo' }}
              </span>
            </td>
            <td>{{ formatDate(client.createdAt) }}</td>
            <td class="actions">
              <button @click="editClient(client.id)" class="btn btn-sm btn-info">
                Editar
              </button>
              <button @click="deleteClient(client.id)" class="btn btn-sm btn-danger">
                Deletar
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-else class="no-clients">
      <p>Nenhum cliente encontrado.</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ClientListPage',
  data() {
    return {
      clients: [],
      searchQuery: '',
      statusFilter: '',
      loading: true,
    };
  },
  computed: {
    filteredClients() {
      return this.clients.filter(client => {
        const matchesSearch =
          client.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
          client.email.toLowerCase().includes(this.searchQuery.toLowerCase());
        const matchesStatus = this.statusFilter === '' || client.status === this.statusFilter;
        return matchesSearch && matchesStatus;
      });
    },
  },
  methods: {
    async fetchClients() {
      try {
        this.loading = true;
        // TODO: Substituir pela chamada real à API
        // const response = await this.$api.get('/clients');
        // this.clients = response.data;
        this.clients = [
          {
            id: 1,
            name: 'João Silva',
            email: 'joao@example.com',
            phone: '11999999999',
            status: 'active',
            createdAt: '2024-01-15',
          },
          {
            id: 2,
            name: 'Maria Santos',
            email: 'maria@example.com',
            phone: '11988888888',
            status: 'active',
            createdAt: '2024-01-20',
          },
        ];
      } catch (error) {
        console.error('Erro ao buscar clientes:', error);
      } finally {
        this.loading = false;
      }
    },
    openAddClientModal() {
      // TODO: Implementar modal de adicionar cliente
      console.log('Abrir modal de novo cliente');
    },
    editClient(clientId) {
      // TODO: Implementar edição de cliente
      console.log('Editar cliente:', clientId);
    },
    deleteClient(clientId) {
      // TODO: Implementar deleção de cliente
      console.log('Deletar cliente:', clientId);
    },
    formatDate(dateString) {
      const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
      return new Date(dateString).toLocaleDateString('pt-BR', options);
    },
  },
  mounted() {
    this.fetchClients();
  },
};
</script>

<style scoped>
.client-list-page {
  padding: 20px;
  background-color: #f5f5f5;
  min-height: 100vh;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.page-header h1 {
  margin: 0;
  color: #333;
  font-size: 28px;
}

.filters {
  display: flex;
  gap: 15px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}

.search-input,
.status-filter {
  padding: 10px 15px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.search-input {
  flex: 1;
  min-width: 250px;
}

.status-filter {
  padding: 10px 15px;
}

.loading,
.no-clients {
  text-align: center;
  padding: 40px;
  background-color: white;
  border-radius: 4px;
  color: #666;
}

.clients-table {
  background-color: white;
  border-radius: 4px;
  overflow: hidden;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

table {
  width: 100%;
  border-collapse: collapse;
}

th {
  background-color: #f9f9f9;
  padding: 15px;
  text-align: left;
  font-weight: 600;
  color: #333;
  border-bottom: 2px solid #ddd;
}

td {
  padding: 15px;
  border-bottom: 1px solid #eee;
  color: #555;
}

tr:hover {
  background-color: #f9f9f9;
}

.status-badge {
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
}

.status-active {
  background-color: #d4edda;
  color: #155724;
}

.status-inactive {
  background-color: #f8d7da;
  color: #721c24;
}

.actions {
  display: flex;
  gap: 10px;
}

.btn {
  padding: 10px 15px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-primary {
  background-color: #007bff;
  color: white;
}

.btn-primary:hover {
  background-color: #0056b3;
}

.btn-info {
  background-color: #17a2b8;
  color: white;
  text-decoration: none;
}

.btn-info:hover {
  background-color: #117a8b;
}

.btn-danger {
  background-color: #dc3545;
  color: white;
}

.btn-danger:hover {
  background-color: #c82333;
}

.btn-sm {
  padding: 6px 10px;
  font-size: 12px;
}
</style>
