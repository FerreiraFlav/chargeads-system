<template>
  <div class="app-wrapper">
    <!-- Sidebar -->
    <Sidebar :collapsed="sidebarCollapsed" @toggle="toggleSidebar" />
    
    <!-- Main Content -->
    <div class="main-content" :class="{ 'sidebar-collapsed': sidebarCollapsed }">
      <!-- Header -->
      <Header 
        :sidebar-collapsed="sidebarCollapsed" 
        @toggle-sidebar="toggleSidebar"
        @logout="handleLogout"
      />
      
      <!-- Page Content -->
      <div class="content">
        <router-view />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from '../components/Sidebar.vue'
import Header from '../components/Header.vue'

const router = useRouter()
const sidebarCollapsed = ref(false)

const toggleSidebar = () => {
  sidebarCollapsed.value = !sidebarCollapsed.value
}

const handleLogout = () => {
  if (confirm('Tem certeza que deseja sair do sistema?')) {
    localStorage.removeItem('loggedIn')
    localStorage.removeItem('username')
    router.push('/login')
  }
}
</script>

