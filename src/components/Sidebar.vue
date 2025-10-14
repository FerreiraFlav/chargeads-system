<template>
  <div class="sidebar" :class="{ collapsed }">
    <div class="sidebar-header">
      <div class="sidebar-brand">
        <div class="brand-logo">
          <div class="logo-icon"></div>
          <span class="logo-text" v-show="!collapsed">ChargeADS</span>
        </div>
      </div>
    </div>

    <nav class="sidebar-nav">
      <ul class="nav">
        <!-- Dashboard -->
        <li class="nav-item">
          <router-link to="/dashboard" class="nav-link" exact-active-class="active">
            <i class="fas fa-tachometer-alt"></i>
            <span v-show="!collapsed">Dashboard</span>
          </router-link>
        </li>

        <!-- Monitoramento Group -->
        <li class="nav-item">
          <div class="nav-group">
            <a 
              href="#" 
              class="nav-link nav-group-toggle" 
              :class="{ collapsed: !monitoramentoOpen }"
              @click.prevent="toggleMonitoramento"
            >
              <i class="fas fa-th"></i>
              <span v-show="!collapsed">Monitoramento</span>
            </a>
            <div class="nav-group-items" :class="{ show: monitoramentoOpen }">
              <router-link to="/dashboard/indicadores" class="nav-link" active-class="active">
                <i class="fas fa-chart-bar"></i>
                <span v-show="!collapsed">Indicadores</span>
              </router-link>
              <router-link to="/dashboard/monitores" class="nav-link" active-class="active">
                <i class="fas fa-desktop"></i>
                <span v-show="!collapsed">Monitores</span>
              </router-link>
              <router-link to="/dashboard/programacoes" class="nav-link" active-class="active">
                <i class="fas fa-calendar"></i>
                <span v-show="!collapsed">Programações</span>
              </router-link>
            </div>
          </div>
        </li>

        <!-- Mídias -->
        <li class="nav-item">
          <router-link to="/dashboard/midias" class="nav-link" active-class="active">
            <i class="fas fa-film"></i>
            <span v-show="!collapsed">Mídias</span>
          </router-link>
        </li>

        <!-- Configurações -->
        <li class="nav-item">
          <router-link to="/dashboard/configuracoes" class="nav-link" active-class="active">
            <i class="fas fa-cogs"></i>
            <span v-show="!collapsed">Configurações</span>
          </router-link>
        </li>
      </ul>
    </nav>

    <!-- Sidebar Footer -->
    <div class="sidebar-footer">
      <div class="user-profile">
        <div class="user-avatar">
          <img src="https://via.placeholder.com/32x32/1ab394/ffffff?text=A" alt="">
        </div>
        <div class="user-info" v-show="!collapsed">
          <div class="user-name">Administrador</div>
          <div class="user-role">Admin</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useRoute } from 'vue-router'

const props = defineProps({
  collapsed: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['toggle'])

const route = useRoute()
const monitoramentoOpen = ref(false)

// Auto-open monitoramento group if on a monitoring page
watch(() => route.path, (newPath) => {
  if (newPath.includes('/dashboard/indicadores') || 
      newPath.includes('/dashboard/monitores') || 
      newPath.includes('/dashboard/programacoes')) {
    monitoramentoOpen.value = true
  }
}, { immediate: true })

const toggleMonitoramento = () => {
  monitoramentoOpen.value = !monitoramentoOpen.value
}
</script>

<style scoped>
.sidebar-header {
  padding: 1rem 1.5rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.sidebar-brand {
  display: flex;
  align-items: center;
}

.brand-logo {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  color: var(--cui-white);
  text-decoration: none;
}

.logo-icon {
  width: 24px;
  height: 20px;
  background: var(--cui-white);
  border-radius: 8px 8px 8px 4px;
  flex-shrink: 0;
}

.logo-text {
  font-size: 1.25rem;
  font-weight: 700;
  white-space: nowrap;
}

.sidebar-footer {
  margin-top: auto;
  padding: 1rem 1.5rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.user-profile {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.5rem;
  border-radius: var(--cui-border-radius);
  transition: var(--cui-transition);
}

.user-profile:hover {
  background: rgba(255, 255, 255, 0.1);
}

.user-avatar img {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  object-fit: cover;
}

.user-info {
  flex: 1;
  min-width: 0;
}

.user-name {
  font-weight: 600;
  color: var(--cui-white);
  font-size: 0.875rem;
}

.user-role {
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.7);
}

.sidebar.collapsed .sidebar-footer {
  padding: 1rem 0.5rem;
}

.sidebar.collapsed .user-info {
  display: none;
}

.sidebar.collapsed .nav-group-items {
  padding-left: 0;
}

.sidebar.collapsed .nav-group-items .nav-link {
  padding-left: 1rem;
  justify-content: center;
}
</style>

