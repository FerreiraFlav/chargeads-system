<template>
  <header class="header">
    <div class="header-left">
      <button class="btn btn-outline sidebar-toggle" @click="$emit('toggle-sidebar')">
        <i class="fas fa-bars" v-if="!sidebarCollapsed"></i>
        <i class="fas fa-indent" v-else></i>
      </button>
      
      <nav class="breadcrumb-nav">
        <ol class="breadcrumb">
          <li class="breadcrumb-item">
            <router-link to="/dashboard">Home</router-link>
          </li>
          <li class="breadcrumb-item active" aria-current="page">
            {{ currentPageTitle }}
          </li>
        </ol>
      </nav>
    </div>

    <div class="header-right">

      <!-- Profile Menu -->
      <div class="user-menu">
        <div class="dropdown">
          <button class="btn btn-outline dropdown-toggle" @click="toggleUserMenu">
            <img :src="userAvatar" class="user-avatar">
            <span class="user-name">{{ username }}</span>
            <i :class="['fas', userMenuOpen ? 'fa-chevron-up' : 'fa-chevron-down']"></i>
          </button>
          
          <div class="dropdown-menu" :class="{ show: userMenuOpen }">
            <a href="#" class="dropdown-item" @click="handleProfile">
              <i class="fas fa-user"></i> Perfil
            </a>
            <a href="#" class="dropdown-item" @click="handleSettings">
              <i class="fas fa-cog"></i> Configurações
            </a>
            <div class="dropdown-divider"></div>
            <a href="#" class="dropdown-item" @click="handleLogout">
              <i class="fas fa-sign-out-alt"></i> Sair
            </a>
          </div>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const props = defineProps({
  sidebarCollapsed: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['toggle-sidebar'])

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const userMenuOpen = ref(false)

const username = computed(() => {
  return authStore.user?.name || authStore.user?.email || ''
})

const userAvatar = computed(() => {
  return authStore.user?.avatar || 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHZpZXdCb3g9IjAgMCAzMiAzMiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMTYiIGN5PSIxNiIgcj0iMTYiIGZpbGw9IndoaXRlIiBzdHJva2U9IndoaXRlIiBzdHJva2Utd2lkdGg9IjEiLz4KPC9zdmc+'
})

const toggleUserMenu = () => {
  userMenuOpen.value = !userMenuOpen.value
}

const closeUserMenu = () => {
  userMenuOpen.value = false
}

const handleProfile = () => {
  closeUserMenu()
  router.push('/dashboard/perfil')
}

const handleSettings = () => {
  closeUserMenu()
  router.push('/dashboard/configuracoes')
}

const handleLogout = async () => {
  if (confirm('Tem certeza que deseja sair do sistema?')) {
    try {
      await authStore.logout()
      router.push('/login')
    } catch (err) {
      console.error('Logout error:', err)
      // Force logout even if there's an error
      router.push('/login')
    }
  }
}

const currentPageTitle = computed(() => {
  const path = route.path
  if (path.includes('indicadores')) return 'Indicadores'
  if (path.includes('monitores')) return 'Monitores'
  if (path.includes('programacoes')) return 'Programações'
  if (path.includes('midias')) return 'Mídias'
  if (path.includes('configuracoes')) return 'Configurações'
  if (path.includes('perfil')) return 'Perfil'
  return 'Dashboard'
})


onMounted(() => {
  // Auth is initialized by router
})

// Close user menu when clicking outside
document.addEventListener('click', (e) => {
  if (!e.target.closest('.user-menu')) {
    userMenuOpen.value = false
  }
})
</script>

<style scoped>
.header-left {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.sidebar-toggle {
  padding: var(--cui-space-3);
  border: none;
  background: transparent;
  color: var(--cui-gray-600);
  font-size: 1.25rem;
  border-radius: var(--cui-border-radius);
  transition: var(--cui-transition);

  &:hover {
    background: var(--cui-gray-100);
    color: var(--cui-gray-800);
  }
}

.breadcrumb-nav {
  margin-left: 1rem;
}

.breadcrumb {
  display: flex;
  list-style: none;
  margin: 0;
  padding: 0;
  gap: 0.5rem;
}

.breadcrumb-item {
  color: var(--cui-gray-600);
  font-size: var(--cui-font-size-base);
  font-weight: var(--cui-font-weight-medium);

  a {
    color: var(--cui-primary);
    text-decoration: none;
    transition: var(--cui-transition);

    &:hover {
      color: var(--cui-primary-700);
    }
  }

  &.active {
    color: var(--cui-gray-800);
    font-weight: var(--cui-font-weight-semibold);
  }
}

.header-right {
  display: flex;
  align-items: center;
  gap: 1rem;
}


.user-menu {
  position: relative;
}

.dropdown-toggle {
  display: flex;
  align-items: center;
  gap: var(--cui-space-2);
  padding: var(--cui-space-2) var(--cui-space-3);
  border: none;
  background: transparent;
  color: var(--cui-gray-700);
  border-radius: var(--cui-border-radius);
  transition: var(--cui-transition);

  &:hover {
    background: var(--cui-gray-100);
    color: var(--cui-gray-800);
  }
}


.user-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  object-fit: cover;
}

.user-name {
  font-weight: var(--cui-font-weight-medium);
  font-size: var(--cui-font-size-base);
}

.dropdown-menu {
  position: absolute;
  top: 100%;
  right: 0;
  background: var(--cui-white);
  border: 1px solid var(--cui-gray-200);
  border-radius: var(--cui-border-radius);
  box-shadow: var(--cui-shadow);
  min-width: 200px;
  z-index: 1000;
  opacity: 0;
  visibility: hidden;
  transform: translateY(-10px);
  transition: all 0.2s ease;

  &.show {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
  }
}

.dropdown-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1rem;
  color: var(--cui-gray-700);
  text-decoration: none;
  transition: var(--cui-transition);

  &:hover {
    background: var(--cui-gray-100);
    color: var(--cui-gray-900);
  }

  i {
    width: 16px;
    text-align: center;
  }
}

.dropdown-divider {
  height: 1px;
  background: var(--cui-gray-200);
  margin: 0.5rem 0;
}

@media (max-width: 768px) {
  .breadcrumb-nav {
    display: none;
  }

  .user-name {
    display: none;
  }
}
</style>

