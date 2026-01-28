<template>
  <div class="client-form-page">
    <div class="form-container">
      <h1>{{ isEditing ? 'Editar Cliente' : 'Novo Cliente' }}</h1>
      
      <form @submit.prevent="handleSubmit">
        <div class="form-group">
          <label for="name">Nome *</label>
          <input 
            id="name"
            v-model="form.name" 
            type="text" 
            placeholder="Nome do cliente"
            required
          />
        </div>

        <div class="form-group">
          <label for="email">Email *</label>
          <input 
            id="email"
            v-model="form.email" 
            type="email" 
            placeholder="email@example.com"
            required
          />
        </div>

        <div class="form-group">
          <label for="phone">Telefone</label>
          <input 
            id="phone"
            v-model="form.phone" 
            type="tel" 
            placeholder="(00) 00000-0000"
          />
        </div>

        <div class="form-group">
          <label for="cpf">CPF</label>
          <input 
            id="cpf"
            v-model="form.cpf" 
            type="text" 
            placeholder="000.000.000-00"
          />
        </div>

        <div class="form-group">
          <label for="address">Endereço</label>
          <input 
            id="address"
            v-model="form.address" 
            type="text" 
            placeholder="Rua, número..."
          />
        </div>

        <div class="form-actions">
          <button type="submit" class="btn btn-primary">
            {{ isEditing ? 'Atualizar' : 'Criar' }}
          </button>
          <button type="button" class="btn btn-secondary" @click="handleCancel">
            Cancelar
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ClientFormPage',
  data() {
    return {
      form: {
        name: '',
        email: '',
        phone: '',
        cpf: '',
        address: ''
      },
      isEditing: false
    }
  },
  mounted() {
    const clientId = this.$route.params.id
    if (clientId) {
      this.isEditing = true
      this.loadClient(clientId)
    }
  },
  methods: {
    loadClient(id) {
      // Load client data from API
      // this.$api.getClient(id).then(data => {
      //   this.form = data
      // })
    },
    handleSubmit() {
      // Submit form data to API
      // if (this.isEditing) {
      //   this.$api.updateClient(this.form.id, this.form)
      // } else {
      //   this.$api.createClient(this.form)
      // }
      console.log('Form submitted:', this.form)
      this.$router.push('/clients')
    },
    handleCancel() {
      this.$router.push('/clients')
    }
  }
}
</script>

<style scoped>
.client-form-page {
  padding: 20px;
  max-width: 600px;
  margin: 0 auto;
}

.form-container {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 30px;
}

.form-container h1 {
  font-size: 24px;
  margin-bottom: 20px;
  color: #333;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 500;
  color: #555;
}

.form-group input {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
}

.form-group input:focus {
  outline: none;
  border-color: #0066cc;
  box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
}

.form-actions {
  display: flex;
  gap: 10px;
  margin-top: 30px;
}

.btn {
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.btn-primary {
  background-color: #0066cc;
  color: white;
}

.btn-primary:hover {
  background-color: #0052a3;
}

.btn-secondary {
  background-color: #f0f0f0;
  color: #333;
}

.btn-secondary:hover {
  background-color: #e0e0e0;
}
</style>
