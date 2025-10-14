<template>
  <div class="login-container">
    <div class="login-card">
      <div class="logo">
        <h1>
          <span class="charge">Charge</span><span class="ads">ADS</span>
        </h1>
        <p class="subtitle">Sistema de Gerenciamento</p>
      </div>

      <!-- Seção de Login -->
      <div v-if="!showRegister" class="login-section">
        <form @submit.prevent="handleLogin">
          <div class="form-group">
            <label for="email">Email</label>
            <div class="input-group">
              <i class="fas fa-envelope"></i>
              <input 
                type="email" 
                id="email" 
                v-model="form.email" 
                class="form-control" 
                placeholder="Digite seu email" 
                required
              >
            </div>
          </div>
          
          <div class="form-group">
            <label for="password">Senha</label>
            <div class="input-group">
              <i class="fas fa-lock"></i>
              <input 
                type="password" 
                id="password" 
                v-model="form.password" 
                class="form-control" 
                placeholder="Digite sua senha" 
                required
              >
            </div>
          </div>

          <div v-if="errorMessage" class="alert alert-danger">
            {{ errorMessage }}
          </div>
          
          <button type="submit" class="btn btn-primary w-100" :disabled="loading">
            <i class="fas fa-sign-in-alt" v-if="!loading"></i>
            <i class="fas fa-spinner fa-spin" v-if="loading"></i>
            {{ loading ? 'Entrando...' : 'Entrar' }}
          </button>
        </form>
        
        <div class="login-footer">
          <p>&copy; 2024 ChargeADS. Todos os direitos reservados.</p>
              <p><small>Use suas credenciais criadas ou crie uma nova conta - Sistema online</small></p>
          <div class="login-actions">
            <button type="button" @click="showRegister = true" class="btn btn-outline btn-sm" :disabled="loading">
              Criar Conta
            </button>
            <button type="button" @click="handleForgotPassword" class="btn btn-link btn-sm" :disabled="loading">
              Esqueci a senha
            </button>
          </div>
        </div>
      </div>

      <!-- Seção de Registro -->
      <div v-if="showRegister" class="register-section">
        <div class="section-header">
          <h3>Criar Nova Conta</h3>
          <button type="button" @click="showRegister = false; clearForm()" class="btn-back">
            <i class="fas fa-arrow-left"></i> Voltar ao Login
          </button>
        </div>

        <form @submit.prevent="handleRegister">
          <div class="form-group">
            <label for="reg-email">Email</label>
            <div class="input-group">
              <i class="fas fa-envelope"></i>
              <input 
                type="email" 
                id="reg-email" 
                v-model="registerForm.email" 
                class="form-control" 
                placeholder="Digite seu email" 
                required
              >
            </div>
          </div>

          <div class="form-group">
            <label for="reg-name">Nome Completo</label>
            <div class="input-group">
              <i class="fas fa-user"></i>
              <input 
                type="text" 
                id="reg-name" 
                v-model="registerForm.full_name" 
                class="form-control" 
                placeholder="Digite seu nome completo" 
                required
              >
            </div>
          </div>
          
          <div class="form-group">
            <label for="reg-password">Senha</label>
            <div class="input-group">
              <i class="fas fa-lock"></i>
              <input 
                type="password" 
                id="reg-password" 
                v-model="registerForm.password" 
                class="form-control" 
                placeholder="Digite uma senha (mín. 6 caracteres)" 
                minlength="6"
                required
              >
            </div>
          </div>

          <div class="form-group">
            <label for="reg-confirm-password">Confirmar Senha</label>
            <div class="input-group">
              <i class="fas fa-lock"></i>
              <input 
                type="password" 
                id="reg-confirm-password" 
                v-model="registerForm.confirmPassword" 
                class="form-control" 
                placeholder="Confirme sua senha" 
                required
              >
            </div>
          </div>

          <div v-if="errorMessage" class="alert alert-danger">
            {{ errorMessage }}
          </div>

          <div v-if="successMessage" class="alert alert-success">
            {{ successMessage }}
            <div v-if="successMessage.includes('sucesso')" class="mt-2">
              <button type="button" @click="goToLogin" class="btn btn-outline btn-sm">
                <i class="fas fa-sign-in-alt"></i> Fazer Login Agora
              </button>
            </div>
          </div>
          
          <button type="submit" class="btn btn-primary w-100" :disabled="loading">
            <i class="fas fa-spinner fa-spin" v-if="loading"></i>
            {{ loading ? 'Criando conta...' : 'Criar Conta' }}
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()
const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')
const showRegister = ref(false)

const form = reactive({
  email: '', // Campo sempre vazio para novos usuários
  password: '' // Campo sempre vazio para novos usuários
})

const registerForm = reactive({
  email: '',
  full_name: '',
  password: '',
  confirmPassword: ''
})

const handleLogin = async () => {
  try {
    loading.value = true
    errorMessage.value = ''
    successMessage.value = ''
    
    console.log('Tentando fazer login com:', form.email)
    const result = await authStore.login(form.email, form.password)
    console.log('Login result:', result)
    console.log('Auth store user:', authStore.user)
    console.log('Is authenticated:', authStore.isAuthenticated)
    
    if (authStore.isAuthenticated) {
      console.log('Redirecionando para dashboard...')
      // Use window.location for hard navigation to avoid router guard issues
      window.location.href = '/dashboard/indicadores'
    } else {
      errorMessage.value = 'Falha ao autenticar. Tente novamente.'
    }
  } catch (err) {
    console.error('Login error:', err)
    
    // Tratar erros específicos do Supabase
    if (err.message && err.message.includes('Email not confirmed')) {
      errorMessage.value = 'Email não confirmado. Verifique sua caixa de entrada ou crie uma nova conta.'
    } else if (err.message && err.message.includes('Invalid login credentials')) {
      errorMessage.value = 'Email ou senha incorretos. Verifique suas credenciais.'
    } else {
      errorMessage.value = err.message || 'Erro ao fazer login. Tente novamente.'
    }
  } finally {
    loading.value = false
  }
}

const handleRegister = async () => {
  try {
    loading.value = true
    errorMessage.value = ''
    successMessage.value = ''
    
    // Validar senhas
    if (registerForm.password !== registerForm.confirmPassword) {
      errorMessage.value = 'As senhas não coincidem.'
      return
    }
    
    if (registerForm.password.length < 6) {
      errorMessage.value = 'A senha deve ter pelo menos 6 caracteres.'
      return
    }
    
    console.log('Tentando criar conta com:', registerForm.email)
    
    // Tentar criar a conta
    const result = await authStore.register(registerForm.email, registerForm.password, {
      full_name: registerForm.full_name
    })
    
    console.log('Resultado do registro:', result)
    
    // Supabase sempre retorna dados, mesmo quando email não está confirmado
    if (result && result.user) {
      if (result.user.email_confirmed_at) {
        // Email já confirmado
        successMessage.value = 'Conta criada com sucesso! Redirecionando para o login...'
      } else {
        // Email precisa ser confirmado
        successMessage.value = 'Conta criada! Verifique seu email para confirmar a conta.'
      }
      
      // Limpar formulário
      registerForm.email = ''
      registerForm.full_name = ''
      registerForm.password = ''
      registerForm.confirmPassword = ''
      
      // Voltar para login após 3 segundos
      setTimeout(() => {
        showRegister.value = false
        successMessage.value = ''
        clearForm()
      }, 3000)
    }
  } catch (err) {
    console.error('Erro ao criar conta:', err)
    errorMessage.value = err.message || 'Erro ao criar conta. Tente novamente.'
  } finally {
    loading.value = false
  }
}

const handleForgotPassword = async () => {
  if (!form.email) {
    errorMessage.value = 'Digite seu email para redefinir a senha.'
    return
  }
  
  try {
    loading.value = true
    errorMessage.value = ''
    
    await authStore.resetPassword(form.email)
    alert('Email de redefinição enviado! Verifique sua caixa de entrada.')
  } catch (err) {
    errorMessage.value = err.message || 'Erro ao enviar email de redefinição.'
    console.error('Reset password error:', err)
  } finally {
    loading.value = false
  }
}

// Função para limpar campos quando voltar para login
const clearForm = () => {
  form.email = ''
  form.password = ''
  errorMessage.value = ''
  successMessage.value = ''
}

const goToLogin = () => {
  showRegister.value = false
  successMessage.value = ''
  clearForm()
}

onMounted(() => {
  // Auth store is initialized by the router
})
</script>

<style scoped>
.charge {
  color: #e55353;
}

.ads {
  color: var(--cui-primary);
}

.subtitle {
  color: var(--cui-gray-600);
  margin-top: 0.5rem;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid var(--cui-gray-200);
}

.section-header h3 {
  margin: 0;
  color: var(--cui-gray-800);
}

.btn-back {
  background: none;
  border: none;
  color: var(--cui-primary);
  cursor: pointer;
  font-size: 0.875rem;
  display: flex;
  align-items: center;
  gap: 0.25rem;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  transition: background-color 0.2s;
}

.btn-back:hover {
  background: var(--cui-gray-50);
}

.input-group {
  position: relative;
}

.input-group i {
  position: absolute;
  left: 1rem;
  top: 50%;
  transform: translateY(-50%);
  color: var(--cui-gray-500);
  z-index: 1;
}

.input-group .form-control {
  padding-left: 3rem;
}

.w-100 {
  width: 100%;
}

.login-footer {
  margin-top: 2rem;
  padding-top: 1.5rem;
  border-top: 1px solid var(--cui-gray-200);
  text-align: center;
  color: var(--cui-gray-600);
  font-size: 0.875rem;
}

.login-footer p {
  margin-bottom: 0.25rem;
}

.login-actions {
  margin-top: 1rem;
  display: flex;
  gap: 0.5rem;
  justify-content: center;
}

.login-actions .btn-sm {
  padding: 0.375rem 0.75rem;
  font-size: 0.875rem;
}

.login-actions .btn-outline {
  background: transparent;
  border: 1px solid var(--cui-gray-300);
  color: var(--cui-gray-600);
}

.login-actions .btn-outline:hover:not(:disabled) {
  background: var(--cui-gray-50);
  border-color: var(--cui-gray-400);
}

.login-actions .btn-link {
  background: transparent;
  border: none;
  color: var(--cui-primary);
  text-decoration: underline;
}

.login-actions .btn-link:hover:not(:disabled) {
  color: var(--cui-primary-700);
}

.alert {
  padding: 0.75rem;
  border-radius: var(--cui-border-radius);
  margin-bottom: 1rem;
}

.alert.alert-danger {
  background: #f8d7da;
  color: #721c24;
  border: 1px solid #f5c6cb;
}

.alert.alert-success {
  background: #d4edda;
  color: #155724;
  border: 1px solid #c3e6cb;
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>