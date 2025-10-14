<template>
  <div class="indicadores-page">
    <!-- Page Header -->
    <div class="page-header">
      <h1 class="page-title">Indicadores</h1>
      <p class="page-subtitle">Monitoramento em tempo real do sistema</p>
    </div>

        <!-- Error Message -->
        <div v-if="error" class="alert alert-danger">
          {{ error }}
          <button @click="error = ''" class="btn btn-sm btn-outline">×</button>
        </div>

        <!-- KPI Cards -->
        <div class="kpi-grid">
          <div class="kpi-card success">
            <div class="kpi-icon">
              <i class="fas fa-check-circle"></i>
            </div>
            <div class="kpi-number">{{ dashboardStats.onlinePlayers }}</div>
            <div class="kpi-label">Players Online</div>
            <div class="kpi-trend positive">
              <i class="fas fa-arrow-up"></i>
              <span>{{ Math.round((dashboardStats.onlinePlayers / dashboardStats.totalPlayers) * 100) }}%</span>
            </div>
          </div>

          <div class="kpi-card warning">
            <div class="kpi-icon">
              <i class="fas fa-exclamation-triangle"></i>
            </div>
            <div class="kpi-number">{{ dashboardStats.unstablePlayers }}</div>
            <div class="kpi-label">Players Instáveis</div>
            <div class="kpi-trend negative">
              <i class="fas fa-arrow-down"></i>
              <span>{{ Math.round((dashboardStats.unstablePlayers / dashboardStats.totalPlayers) * 100) }}%</span>
            </div>
          </div>

          <div class="kpi-card danger">
            <div class="kpi-icon">
              <i class="fas fa-times-circle"></i>
            </div>
            <div class="kpi-number">{{ dashboardStats.offlinePlayers }}</div>
            <div class="kpi-label">Players Offline</div>
            <div class="kpi-trend negative">
              <i class="fas fa-arrow-up"></i>
              <span>{{ Math.round((dashboardStats.offlinePlayers / dashboardStats.totalPlayers) * 100) }}%</span>
            </div>
          </div>

          <div class="kpi-card info">
            <div class="kpi-icon">
              <i class="fas fa-chart-line"></i>
            </div>
            <div class="kpi-number">{{ Math.round(dashboardStats.avgUptime) }}%</div>
            <div class="kpi-label">Uptime Médio</div>
            <div class="kpi-trend positive">
              <i class="fas fa-arrow-up"></i>
              <span>+2.3%</span>
            </div>
          </div>
        </div>

    <!-- Players Section -->
    <div class="card">
      <div class="card-header">
        <h5>Status dos Players</h5>
        <div class="card-actions">
          <button @click="refreshData" class="btn btn-outline btn-sm" :disabled="loading">
            <i class="fas fa-sync-alt" :class="{ 'fa-spin': loading }"></i> 
            {{ loading ? 'Atualizando...' : 'Atualizar' }}
          </button>
        </div>
      </div>
      <div class="card-body">
        <div v-if="loading && players.length === 0" class="text-center py-4">
          <i class="fas fa-spinner fa-spin fa-2x text-muted"></i>
          <p class="mt-2 text-muted">Carregando players...</p>
        </div>
        
        <div v-else-if="players.length === 0" class="text-center py-4">
          <i class="fas fa-desktop fa-2x text-muted"></i>
          <p class="mt-2 text-muted">Nenhum player encontrado</p>
        </div>
        
        <div v-else class="players-grid">
          <div 
            v-for="player in players" 
            :key="player.id" 
            :class="['player-item', player.status]"
          >
            <div class="player-icon">
              <i class="fas fa-desktop"></i>
            </div>
            <div class="player-info">
              <div class="player-id">#{{ player.id.slice(-4) }}</div>
              <div class="player-name">{{ player.name }}</div>
              <div class="player-description" v-if="player.description">
                {{ player.description }}
              </div>
              <div class="player-location" v-if="player.location">
                <i class="fas fa-map-marker-alt"></i> {{ player.location }}
              </div>
              <div class="player-status">{{ player.status }}</div>
              <div class="player-uptime" v-if="player.player_statistics?.[0]">
                <i class="fas fa-chart-line"></i> 
                Uptime: {{ Math.round(player.player_statistics[0].uptime_percentage) }}%
              </div>
              <div class="player-last-seen" v-if="player.last_seen_at">
                <i class="fas fa-clock"></i> 
                Último visto: {{ formatDate(player.last_seen_at) }}
              </div>
            </div>
            <div class="player-actions" v-if="authStore.isAdmin">
              <button 
                @click="updatePlayerStatus(player.id, 'online')" 
                class="btn btn-sm btn-success"
                :disabled="player.status === 'online'"
              >
                <i class="fas fa-play"></i>
              </button>
              <button 
                @click="updatePlayerStatus(player.id, 'offline')" 
                class="btn btn-sm btn-danger"
                :disabled="player.status === 'offline'"
              >
                <i class="fas fa-stop"></i>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { usePlayersStore } from '@/stores/players'
import { useAuthStore } from '@/stores/auth'

const playersStore = usePlayersStore()
const authStore = useAuthStore()

const loading = ref(false)
const error = ref('')

// Computed properties for dashboard data
const dashboardStats = computed(() => {
  if (playersStore.dashboardData) {
    return {
      totalPlayers: playersStore.dashboardData.total_players || 0,
      onlinePlayers: playersStore.dashboardData.online_players || 0,
      offlinePlayers: playersStore.dashboardData.offline_players || 0,
      unstablePlayers: playersStore.dashboardData.unstable_players || 0,
      avgUptime: playersStore.dashboardData.avg_uptime || 0
    }
  }
  return {
    totalPlayers: 0,
    onlinePlayers: 0,
    offlinePlayers: 0,
    unstablePlayers: 0,
    avgUptime: 0
  }
})

const players = computed(() => playersStore.players)
const recentLogs = computed(() => playersStore.playerLogs)

const refreshData = async () => {
  try {
    loading.value = true
    error.value = ''
    
    await Promise.all([
      playersStore.fetchPlayers(),
      playersStore.fetchDashboardData(),
      playersStore.fetchPlayerLogs()
    ])
  } catch (err) {
    error.value = err.message || 'Erro ao carregar dados'
    console.error('Error refreshing data:', err)
  } finally {
    loading.value = false
  }
}

const updatePlayerStatus = async (playerId, status) => {
  try {
    await playersStore.updatePlayerStatus(playerId, status, 'Status atualizado manualmente')
  } catch (err) {
    error.value = err.message || 'Erro ao atualizar status do player'
    console.error('Error updating player status:', err)
  }
}

const formatDate = (dateString) => {
  if (!dateString) return 'Nunca'
  
  const date = new Date(dateString)
  const now = new Date()
  const diffMs = now - date
  const diffMins = Math.floor(diffMs / 60000)
  const diffHours = Math.floor(diffMs / 3600000)
  const diffDays = Math.floor(diffMs / 86400000)
  
  if (diffMins < 1) return 'Agora'
  if (diffMins < 60) return `${diffMins}min atrás`
  if (diffHours < 24) return `${diffHours}h atrás`
  if (diffDays < 7) return `${diffDays}d atrás`
  
  return date.toLocaleDateString('pt-BR')
}

let refreshInterval = null

onMounted(async () => {
  // Initialize players store
  await playersStore.init()
  
  // Load initial data
  await refreshData()
  
  // Set up auto-refresh every 30 seconds
  refreshInterval = setInterval(refreshData, 30000)
})

onUnmounted(() => {
  if (refreshInterval) {
    clearInterval(refreshInterval)
  }
})
</script>

<style scoped>
.indicadores-page {
  width: 100%;
  height: 100%;
}

.kpi-trend {
  &.positive {
    color: rgba(255, 255, 255, 0.9);
  }

  &.negative {
    color: rgba(255, 255, 255, 0.9);
  }
}

.player-item {
  display: flex;
  align-items: center;
  gap: var(--cui-space-4);
  padding: var(--cui-space-4);
  border-radius: var(--cui-border-radius-lg);
  border: 1px solid var(--cui-gray-200);
  transition: var(--cui-transition);
  background: var(--cui-white);

  &:hover {
    box-shadow: var(--cui-shadow);
    transform: translateY(-2px);
  }

  &.online {
    border-left: 4px solid var(--cui-success);
    background: rgba(var(--cui-success-rgb), 0.05);
  }

  &.offline {
    border-left: 4px solid var(--cui-danger);
    background: rgba(var(--cui-danger-rgb), 0.05);
  }
}

.player-icon {
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--cui-border-radius-full);
  font-size: 1.5rem;
  flex-shrink: 0;

  .player-item.online & {
    background: rgba(var(--cui-success-rgb), 0.1);
    color: var(--cui-success);
  }

  .player-item.offline & {
    background: rgba(var(--cui-danger-rgb), 0.1);
    color: var(--cui-danger);
  }
}

.player-info {
  flex: 1;
  min-width: 0;
}

.player-id {
  font-weight: var(--cui-font-weight-semibold);
  color: var(--cui-primary);
  font-size: var(--cui-font-size-sm);
  margin-bottom: var(--cui-space-1);
}

.player-name {
  font-weight: var(--cui-font-weight-medium);
  color: var(--cui-gray-800);
  font-size: var(--cui-font-size-base);
  margin-bottom: var(--cui-space-1);
  line-height: var(--cui-line-height-tight);
}

.player-description {
  font-size: var(--cui-font-size-sm);
  color: var(--cui-gray-600);
  margin-bottom: var(--cui-space-1);
  line-height: var(--cui-line-height-normal);
}

.player-location {
  font-size: var(--cui-font-size-xs);
  color: var(--cui-gray-500);
  margin-bottom: var(--cui-space-1);
  display: flex;
  align-items: center;
  gap: var(--cui-space-1);

  i {
    font-size: 0.75rem;
  }
}

.player-status {
  font-size: var(--cui-font-size-xs);
  font-weight: var(--cui-font-weight-medium);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: var(--cui-space-1);

  .player-item.online & {
    color: var(--cui-success);
  }

  .player-item.offline & {
    color: var(--cui-danger);
  }

  .player-item.unstable & {
    color: var(--cui-warning);
  }
}

.player-uptime {
  font-size: var(--cui-font-size-xs);
  color: var(--cui-gray-500);
  margin-bottom: var(--cui-space-1);
  display: flex;
  align-items: center;
  gap: var(--cui-space-1);

  i {
    font-size: 0.75rem;
  }
}

.player-last-seen {
  font-size: var(--cui-font-size-xs);
  color: var(--cui-gray-500);
  display: flex;
  align-items: center;
  gap: var(--cui-space-1);

  i {
    font-size: 0.75rem;
  }
}

.player-actions {
  display: flex;
  gap: var(--cui-space-2);
  margin-left: auto;

  .btn-sm {
    padding: var(--cui-space-2);
    min-width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;

    i {
      font-size: 0.75rem;
    }
  }
}

.text-center {
  text-align: center;
}

.py-4 {
  padding-top: var(--cui-space-4);
  padding-bottom: var(--cui-space-4);
}

.text-muted {
  color: var(--cui-gray-500);
}

.mt-2 {
  margin-top: var(--cui-space-2);
}

.fa-2x {
  font-size: 2em;
}
</style>
