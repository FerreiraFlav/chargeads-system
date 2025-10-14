import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import Login from '@/views/Login.vue'
import Dashboard from '@/views/Dashboard.vue'
import Indicadores from '@/views/Indicadores.vue'
import Monitores from '@/views/Monitores.vue'
import Programacoes from '@/views/Programacoes.vue'
import Midias from '@/views/Midias.vue'
import Configuracoes from '@/views/Configuracoes.vue'
import Perfil from '@/views/Perfil.vue'

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'Login',
    component: Login,
    meta: { requiresGuest: true }
  },
  {
    path: '/dashboard',
    component: Dashboard,
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        redirect: '/dashboard/indicadores'
      },
      {
        path: 'indicadores',
        name: 'Indicadores',
        component: Indicadores,
        meta: { 
          requiresAuth: true,
          breadcrumb: 'Indicadores'
        }
      },
      {
        path: 'monitores',
        name: 'Monitores',
        component: Monitores,
        meta: { 
          requiresAuth: true,
          breadcrumb: 'Monitores'
        }
      },
      {
        path: 'programacoes',
        name: 'Programacoes',
        component: Programacoes,
        meta: { 
          requiresAuth: true,
          breadcrumb: 'Programações'
        }
      },
      {
        path: 'midias',
        name: 'Midias',
        component: Midias,
        meta: { 
          requiresAuth: true,
          breadcrumb: 'Mídias'
        }
      },
      {
        path: 'configuracoes',
        name: 'Configuracoes',
        component: Configuracoes,
        meta: { 
          requiresAuth: true,
          breadcrumb: 'Configurações'
        }
      },
      {
        path: 'perfil',
        name: 'Perfil',
        component: Perfil,
        meta: { 
          requiresAuth: true,
          breadcrumb: 'Perfil'
        }
      }
    ]
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/login'
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// Navigation guards
let isAuthInitialized = false

router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore()
  
  // Initialize auth store only once
  if (!isAuthInitialized) {
    await authStore.init()
    isAuthInitialized = true
  }
  
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth)
  const requiresGuest = to.matched.some(record => record.meta.requiresGuest)
  const isAuthenticated = authStore.isAuthenticated
  
  console.log('Router guard:', { to: to.path, requiresAuth, requiresGuest, isAuthenticated })
  
  if (requiresAuth && !isAuthenticated) {
    // Redirect to login if trying to access protected route without auth
    console.log('Redirecting to login - not authenticated')
    next('/login')
  } else if (requiresGuest && isAuthenticated) {
    // Redirect to dashboard if trying to access guest route while authenticated
    console.log('Redirecting to dashboard - already authenticated')
    next('/dashboard/indicadores')
  } else {
    console.log('Allowing navigation to:', to.path)
    next()
  }
})

export default router
