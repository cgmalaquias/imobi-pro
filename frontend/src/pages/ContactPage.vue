<template>
  <div class="contact-page">
    <div class="container">
      <h1>Entre em Contato</h1>
      <p class="subtitle">Tem dúvidas? Envie uma mensagem para nosso time</p>

      <div class="contact-content">
        <!-- Formulário de Contato -->
        <div class="contact-form">
          <h2>Formulário de Contato</h2>
          <form @submit.prevent="submitForm">
            <div class="form-group">
              <label for="name">Nome Completo *</label>
              <input
                v-model="form.name"
                type="text"
                id="name"
                placeholder="Seu nome completo"
                required
              />
            </div>

            <div class="form-group">
              <label for="email">Email *</label>
              <input
                v-model="form.email"
                type="email"
                id="email"
                placeholder="seu@email.com"
                required
              />
            </div>

            <div class="form-group">
              <label for="phone">Telefone</label>
              <input
                v-model="form.phone"
                type="tel"
                id="phone"
                placeholder="(11) 99999-9999"
              />
            </div>

            <div class="form-group">
              <label for="subject">Assunto *</label>
              <select v-model="form.subject" id="subject" required>
                <option value="">Selecione um assunto</option>
                <option value="duvida">Dúvida</option>
                <option value="sugestao">Sugestão</option>
                <option value="reclamacao">Reclamação</option>
                <option value="outro">Outro</option>
              </select>
            </div>

            <div class="form-group">
              <label for="message">Mensagem *</label>
              <textarea
                v-model="form.message"
                id="message"
                placeholder="Escreva sua mensagem aqui..."
                rows="6"
                required
              ></textarea>
            </div>

            <div class="form-group checkbox">
              <input
                v-model="form.newsletter"
                type="checkbox"
                id="newsletter"
              />
              <label for="newsletter">
                Desejo receber notícias e atualizações por email
              </label>
            </div>

            <button type="submit" class="btn-submit">Enviar Mensagem</button>
          </form>

          <div v-if="successMessage" class="alert alert-success">
            {{ successMessage }}
          </div>
          <div v-if="errorMessage" class="alert alert-error">
            {{ errorMessage }}
          </div>
        </div>

        <!-- Informações de Contato -->
        <div class="contact-info">
          <h2>Informações de Contato</h2>

          <div class="info-item">
            <h3>Endereço</h3>
            <p>
              Rua Exemplo, 123<br />
              São Paulo, SP 01234-567<br />
              Brasil
            </p>
          </div>

          <div class="info-item">
            <h3>Telefone</h3>
            <p>
              <a href="tel:+551133333333">(11) 3333-3333</a><br />
              <a href="tel:+5511999999999">(11) 99999-9999</a>
            </p>
          </div>

          <div class="info-item">
            <h3>Email</h3>
            <p>
              <a href="mailto:contato@imobi.com">contato@imobi.com</a><br />
              <a href="mailto:suporte@imobi.com">suporte@imobi.com</a>
            </p>
          </div>

          <div class="info-item">
            <h3>Horário de Atendimento</h3>
            <p>
              Segunda a Sexta: 09h - 18h<br />
              Sábado: 09h - 13h<br />
              Domingo: Fechado
            </p>
          </div>

          <div class="social-links">
            <h3>Redes Sociais</h3>
            <div class="social-icons">
              <a href="#" class="social-icon">Facebook</a>
              <a href="#" class="social-icon">Instagram</a>
              <a href="#" class="social-icon">WhatsApp</a>
              <a href="#" class="social-icon">LinkedIn</a>
            </div>
          </div>
        </div>
      </div>

      <!-- Mensagens Recentes -->
      <div class="messages-section">
        <h2>Minhas Mensagens</h2>
        <div v-if="messages.length === 0" class="no-messages">
          <p>Nenhuma mensagem enviada ainda.</p>
        </div>
        <div v-else class="messages-list">
          <div v-for="msg in messages" :key="msg.id" class="message-card">
            <div class="message-header">
              <h4>{{ msg.subject }}</h4>
              <span class="message-date">{{ formatDate(msg.createdAt) }}</span>
            </div>
            <p class="message-content">{{ msg.message }}</p>
            <div class="message-status">
              <span :class="['status', msg.status]">
                {{ msg.status === 'responded' ? 'Respondido' : 'Pendente' }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ContactPage',
  data() {
    return {
      form: {
        name: '',
        email: '',
        phone: '',
        subject: '',
        message: '',
        newsletter: false,
      },
      messages: [
        // Exemplo de mensagem
        // {
        //   id: 1,
        //   subject: 'Dúvida sobre propriedade',
        //   message: 'Tenho dúvidas sobre a propriedade X',
        //   createdAt: new Date(),
        //   status: 'responded'
        // }
      ],
      successMessage: '',
      errorMessage: '',
    };
  },
  methods: {
    submitForm() {
      // Validação básica
      if (!this.form.name || !this.form.email || !this.form.subject || !this.form.message) {
        this.errorMessage = 'Por favor, preencha todos os campos obrigatórios.';
        return;
      }

      // Simular envio da mensagem
      try {
        const newMessage = {
          id: this.messages.length + 1,
          ...this.form,
          createdAt: new Date(),
          status: 'pending',
        };

        this.messages.unshift(newMessage);
        this.successMessage = 'Mensagem enviada com sucesso! Entraremos em contato em breve.';

        // Limpar formulário
        this.resetForm();

        // Limpar mensagem de sucesso após 5 segundos
        setTimeout(() => {
          this.successMessage = '';
        }, 5000);
      } catch (error) {
        this.errorMessage = 'Erro ao enviar mensagem. Tente novamente.';
      }
    },
    resetForm() {
      this.form = {
        name: '',
        email: '',
        phone: '',
        subject: '',
        message: '',
        newsletter: false,
      };
    },
    formatDate(date) {
      return new Date(date).toLocaleDateString('pt-BR', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
      });
    },
  },
};
</script>

<style scoped>
.contact-page {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
  padding: 40px 20px;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
}

h1 {
  text-align: center;
  color: white;
  font-size: 3rem;
  margin-bottom: 10px;
}

.subtitle {
  text-align: center;
  color: rgba(255, 255, 255, 0.9);
  font-size: 1.1rem;
  margin-bottom: 50px;
}

.contact-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 40px;
  margin-bottom: 50px;
}

.contact-form,
.contact-info {
  background: white;
  padding: 40px;
  border-radius: 10px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

.contact-form h2,
.contact-info h2 {
  color: #333;
  margin-bottom: 30px;
  font-size: 1.8rem;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  color: #333;
  font-weight: 500;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 12px;
  border: 2px solid #e0e0e0;
  border-radius: 5px;
  font-size: 1rem;
  font-family: inherit;
  transition: border-color 0.3s ease;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #667eea;
}

.form-group.checkbox {
  display: flex;
  align-items: center;
}

.form-group.checkbox input {
  width: auto;
  margin-right: 10px;
  cursor: pointer;
}

.form-group.checkbox label {
  margin: 0;
  cursor: pointer;
}

.btn-submit {
  width: 100%;
  padding: 14px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 5px;
  font-size: 1.1rem;
  font-weight: bold;
  cursor: pointer;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.btn-submit:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
}

.alert {
  margin-top: 20px;
  padding: 15px;
  border-radius: 5px;
  font-weight: 500;
}

.alert-success {
  background-color: #d4edda;
  color: #155724;
  border: 1px solid #c3e6cb;
}

.alert-error {
  background-color: #f8d7da;
  color: #721c24;
  border: 1px solid #f5c6cb;
}

.info-item {
  margin-bottom: 30px;
}

.info-item h3 {
  color: #667eea;
  margin-bottom: 10px;
  font-size: 1.1rem;
}

.info-item p {
  color: #666;
  line-height: 1.6;
}

.info-item a {
  color: #667eea;
  text-decoration: none;
  transition: color 0.3s ease;
}

.info-item a:hover {
  color: #764ba2;
}

.social-links {
  margin-top: 40px;
  padding-top: 30px;
  border-top: 2px solid #e0e0e0;
}

.social-icons {
  display: flex;
  gap: 15px;
  flex-wrap: wrap;
}

.social-icon {
  display: inline-block;
  padding: 10px 20px;
  background: #f0f0f0;
  color: #667eea;
  text-decoration: none;
  border-radius: 5px;
  transition: all 0.3s ease;
}

.social-icon:hover {
  background: #667eea;
  color: white;
}

.messages-section {
  background: white;
  padding: 40px;
  border-radius: 10px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

.messages-section h2 {
  color: #333;
  margin-bottom: 30px;
  font-size: 1.8rem;
}

.no-messages {
  text-align: center;
  padding: 40px 20px;
  color: #999;
  font-size: 1.1rem;
}

.messages-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.message-card {
  background: #f9f9f9;
  padding: 20px;
  border-radius: 8px;
  border-left: 4px solid #667eea;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.message-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}

.message-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 15px;
}

.message-header h4 {
  color: #333;
  margin: 0;
  font-size: 1.1rem;
}

.message-date {
  color: #999;
  font-size: 0.9rem;
  white-space: nowrap;
  margin-left: 10px;
}

.message-content {
  color: #666;
  margin-bottom: 15px;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.message-status {
  display: flex;
  justify-content: flex-end;
}

.status {
  display: inline-block;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 0.85rem;
  font-weight: 500;
}

.status.pending {
  background-color: #fff3cd;
  color: #856404;
}

.status.responded {
  background-color: #d4edda;
  color: #155724;
}

/* Responsivo */
@media (max-width: 768px) {
  .contact-content {
    grid-template-columns: 1fr;
    gap: 30px;
  }

  h1 {
    font-size: 2rem;
  }

  .contact-form,
  .contact-info {
    padding: 25px;
  }

  .messages-list {
    grid-template-columns: 1fr;
  }
}
</style>
