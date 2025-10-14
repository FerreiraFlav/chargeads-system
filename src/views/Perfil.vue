<template>
  <div class="perfil-container">
    <div class="page-header">
      <h1 class="page-title">Perfil do Usuário</h1>
      <p class="page-subtitle">Gerencie suas informações pessoais e configurações de conta</p>
    </div>

    <div class="perfil-content">
      <!-- Informações Pessoais -->
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">
            <i class="fas fa-user"></i>
            Informações Pessoais
          </h3>
        </div>
        <div class="card-body">
          <form @submit.prevent="updateProfile" class="profile-form">
            <div class="form-row">
              <div class="form-group">
                <label for="fullName">Nome Completo</label>
                <input 
                  type="text" 
                  id="fullName"
                  v-model="profileForm.full_name" 
                  class="form-control"
                  placeholder="Digite seu nome completo"
                >
              </div>
              <div class="form-group">
                <label for="email">Email</label>
                <input 
                  type="email" 
                  id="email"
                  v-model="profileForm.email" 
                  class="form-control"
                  placeholder="Digite seu email"
                  readonly
                >
              </div>
            </div>
            
            <div class="form-row">
              <div class="form-group">
                <label for="phone">Telefone</label>
                <input 
                  type="tel" 
                  id="phone"
                  v-model="profileForm.phone" 
                  class="form-control"
                  placeholder="(11) 99999-9999"
                >
              </div>
              <div class="form-group">
                <label for="role">Função</label>
                <select id="role" v-model="profileForm.role" class="form-control">
                  <option value="admin">Administrador</option>
                  <option value="user">Usuário</option>
                </select>
              </div>
            </div>

            <div class="form-actions">
              <button type="submit" class="btn btn-primary" :disabled="loading">
                <i class="fas fa-save" v-if="!loading"></i>
                <i class="fas fa-spinner fa-spin" v-if="loading"></i>
                {{ loading ? 'Salvando...' : 'Salvar Alterações' }}
              </button>
            </div>
          </form>
        </div>
      </div>

      <!-- Alterar Senha -->
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">
            <i class="fas fa-lock"></i>
            Alterar Senha
          </h3>
        </div>
        <div class="card-body">
          <form @submit.prevent="changePassword" class="password-form">
            <div class="form-group">
              <label for="currentPassword">Senha Atual</label>
              <input 
                type="password" 
                id="currentPassword"
                v-model="passwordForm.currentPassword" 
                class="form-control"
                placeholder="Digite sua senha atual"
                required
              >
            </div>
            
            <div class="form-row">
              <div class="form-group">
                <label for="newPassword">Nova Senha</label>
                <input 
                  type="password" 
                  id="newPassword"
                  v-model="passwordForm.newPassword" 
                  class="form-control"
                  placeholder="Digite a nova senha"
                  required
                >
              </div>
              <div class="form-group">
                <label for="confirmPassword">Confirmar Nova Senha</label>
                <input 
                  type="password" 
                  id="confirmPassword"
                  v-model="passwordForm.confirmPassword" 
                  class="form-control"
                  placeholder="Confirme a nova senha"
                  required
                >
              </div>
            </div>

            <div class="form-actions">
              <button type="submit" class="btn btn-warning" :disabled="loading">
                <i class="fas fa-key" v-if="!loading"></i>
                <i class="fas fa-spinner fa-spin" v-if="loading"></i>
                {{ loading ? 'Alterando...' : 'Alterar Senha' }}
              </button>
            </div>
          </form>
        </div>
      </div>

      <!-- Informações da Conta -->
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">
            <i class="fas fa-info-circle"></i>
            Informações da Conta
          </h3>
        </div>
        <div class="card-body">
          <div class="info-grid">
            <div class="info-item">
              <label>ID do Usuário</label>
              <span>{{ userInfo.id }}</span>
            </div>
            <div class="info-item">
              <label>Data de Criação</label>
              <span>{{ formatDate(userInfo.created_at) }}</span>
            </div>
            <div class="info-item">
              <label>Último Acesso</label>
              <span>{{ formatDate(userInfo.last_sign_in_at) }}</span>
            </div>
            <div class="info-item">
              <label>Status da Conta</label>
              <span class="status-badge active">Ativa</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
const loading = ref(false)

// Formulário de perfil
const profileForm = reactive({
  full_name: '',
  email: '',
  phone: '',
  role: 'admin'
})

// Formulário de senha
const passwordForm = reactive({
  currentPassword: '',
  newPassword: '',
  confirmPassword: ''
})

// Informações do usuário
const userInfo = ref({
  id: '',
  created_at: '',
  last_sign_in_at: ''
})

const updateProfile = async () => {
  loading.value = true
  try {
    // Aqui você implementaria a lógica para atualizar o perfil
    console.log('Atualizando perfil:', profileForm)
    
    // Simulação de sucesso
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    alert('Perfil atualizado com sucesso!')
  } catch (error) {
    console.error('Erro ao atualizar perfil:', error)
    alert('Erro ao atualizar perfil. Tente novamente.')
  } finally {
    loading.value = false
  }
}

const changePassword = async () => {
  if (passwordForm.newPassword !== passwordForm.confirmPassword) {
    alert('As senhas não coincidem!')
    return
  }

  if (passwordForm.newPassword.length < 6) {
    alert('A nova senha deve ter pelo menos 6 caracteres!')
    return
  }

  loading.value = true
  try {
    // Aqui você implementaria a lógica para alterar a senha
    console.log('Alterando senha:', passwordForm)
    
    // Simulação de sucesso
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    alert('Senha alterada com sucesso!')
    
    // Limpar formulário
    passwordForm.currentPassword = ''
    passwordForm.newPassword = ''
    passwordForm.confirmPassword = ''
  } catch (error) {
    console.error('Erro ao alterar senha:', error)
    alert('Erro ao alterar senha. Verifique a senha atual e tente novamente.')
  } finally {
    loading.value = false
  }
}

const formatDate = (dateString) => {
  if (!dateString) return 'N/A'
  return new Date(dateString).toLocaleString('pt-BR')
}

const loadUserInfo = () => {
  if (authStore.user) {
    profileForm.full_name = authStore.user.name || ''
    profileForm.email = authStore.user.email || ''
    profileForm.phone = authStore.user.phone || ''
    profileForm.role = authStore.user.role || 'admin'
    
    userInfo.value = {
      id: authStore.user.id || 'N/A',
      created_at: authStore.user.created_at || '',
      last_sign_in_at: authStore.user.last_sign_in_at || ''
    }
  }
}

onMounted(() => {
  loadUserInfo()
})
</script>

<style scoped>
.perfil-container {
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 2rem;
}

.page-title {
  font-size: 2rem;
  font-weight: 700;
  color: var(--cui-gray-900);
  margin-bottom: 0.5rem;
}

.page-subtitle {
  color: var(--cui-gray-600);
  font-size: 1.1rem;
}

.perfil-content {
  display: grid;
  gap: 2rem;
}

.card {
  background: var(--cui-white);
  border-radius: var(--cui-border-radius-lg);
  box-shadow: var(--cui-shadow);
  overflow: hidden;
}

.card-header {
  padding: 1.5rem;
  border-bottom: 1px solid var(--cui-gray-200);
  background: var(--cui-gray-50);
}

.card-title {
  font-size: 1.25rem;
  font-weight: 600;
  color: var(--cui-gray-900);
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.card-body {
  padding: 1.5rem;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-bottom: 1rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group label {
  font-weight: 500;
  color: var(--cui-gray-700);
  font-size: 0.875rem;
}

.form-control {
  padding: 0.75rem;
  border: 1px solid var(--cui-gray-300);
  border-radius: var(--cui-border-radius);
  font-size: 1rem;
  transition: var(--cui-transition);
}

.form-control:focus {
  outline: none;
  border-color: var(--cui-primary);
  box-shadow: 0 0 0 3px rgba(26, 179, 148, 0.1);
}

.form-control[readonly] {
  background: var(--cui-gray-100);
  color: var(--cui-gray-600);
}

.form-actions {
  margin-top: 1.5rem;
  display: flex;
  gap: 1rem;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  padding: 1rem;
  background: var(--cui-gray-50);
  border-radius: var(--cui-border-radius);
}

.info-item label {
  font-weight: 500;
  color: var(--cui-gray-600);
  font-size: 0.875rem;
}

.info-item span {
  color: var(--cui-gray-900);
  font-weight: 500;
}

.status-badge {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  border-radius: var(--cui-border-radius-full);
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
}

.status-badge.active {
  background: var(--cui-success-light);
  color: var(--cui-success-dark);
}

@media (max-width: 768px) {
  .perfil-container {
    padding: 1rem;
  }
  
  .form-row {
    grid-template-columns: 1fr;
  }
  
  .info-grid {
    grid-template-columns: 1fr;
  }
}
</style>
