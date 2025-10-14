import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase, dbHelpers, realtimeHelpers } from '@/config/supabase'

export const usePlayersStore = defineStore('players', () => {
  const players = ref([])
  const playerStatistics = ref({})
  const playerLogs = ref([])
  const dashboardData = ref(null)
  const loading = ref(false)
  const error = ref(null)

  // Computed properties
  const onlinePlayers = computed(() => 
    players.value.filter(player => player.status === 'online')
  )
  
  const offlinePlayers = computed(() => 
    players.value.filter(player => player.status === 'offline')
  )
  
  const unstablePlayers = computed(() => 
    players.value.filter(player => player.status === 'unstable')
  )

  const totalPlayers = computed(() => players.value.length)
  const onlineCount = computed(() => onlinePlayers.value.length)
  const offlineCount = computed(() => offlinePlayers.value.length)
  const unstableCount = computed(() => unstablePlayers.value.length)

  // Actions
  const fetchPlayers = async () => {
    try {
      loading.value = true
      error.value = null

      const { data, error: fetchError } = await supabase
        .from('players')
        .select(`
          *,
          player_statistics (*)
        `)
        .eq('is_active', true)
        .order('name')

      if (fetchError) throw fetchError

      players.value = data || []
      return data
    } catch (err) {
      error.value = err.message
      console.error('Error fetching players:', err)
      throw err
    } finally {
      loading.value = false
    }
  }

  const fetchPlayer = async (playerId) => {
    try {
      loading.value = true
      error.value = null

      const { data, error: fetchError } = await supabase
        .from('players')
        .select(`
          *,
          player_statistics (*)
        `)
        .eq('id', playerId)
        .single()

      if (fetchError) throw fetchError

      return data
    } catch (err) {
      error.value = err.message
      console.error('Error fetching player:', err)
      throw err
    } finally {
      loading.value = false
    }
  }

  const fetchDashboardData = async () => {
    try {
      loading.value = true
      error.value = null

      const { data, error: fetchError } = await supabase.rpc('get_player_dashboard')

      if (fetchError) throw fetchError

      dashboardData.value = data[0] // Function returns table, so we get first row
      return dashboardData.value
    } catch (err) {
      error.value = err.message
      console.error('Error fetching dashboard data:', err)
      throw err
    } finally {
      loading.value = false
    }
  }

  const fetchPlayerLogs = async (limit = 50) => {
    try {
      loading.value = true
      error.value = null

      const { data, error: fetchError } = await supabase
        .from('player_logs')
        .select(`
          *,
          players (name)
        `)
        .order('created_at', { ascending: false })
        .limit(limit)

      if (fetchError) throw fetchError

      playerLogs.value = data || []
      return data
    } catch (err) {
      error.value = err.message
      console.error('Error fetching player logs:', err)
      throw err
    } finally {
      loading.value = false
    }
  }

  const updatePlayerStatus = async (playerId, status, message = null, responseTime = null) => {
    try {
      loading.value = true
      error.value = null

      const { data, error: updateError } = await supabase.rpc('update_player_status', {
        p_player_id: playerId,
        p_status: status,
        p_message: message,
        p_response_time: responseTime
      })

      if (updateError) throw updateError

      // Update local state
      await fetchPlayers()
      await fetchDashboardData()

      return data
    } catch (err) {
      error.value = err.message
      console.error('Error updating player status:', err)
      throw err
    } finally {
      loading.value = false
    }
  }

  const createPlayer = async (playerData) => {
    try {
      loading.value = true
      error.value = null

      const { data, error: createError } = await supabase
        .from('players')
        .insert([{
          ...playerData,
          created_by: (await supabase.auth.getUser()).data.user?.id
        }])
        .select()
        .single()

      if (createError) throw createError

      // Refresh players list
      await fetchPlayers()

      return data
    } catch (err) {
      error.value = err.message
      console.error('Error creating player:', err)
      throw err
    } finally {
      loading.value = false
    }
  }

  const updatePlayer = async (playerId, updates) => {
    try {
      loading.value = true
      error.value = null

      const { data, error: updateError } = await supabase
        .from('players')
        .update(updates)
        .eq('id', playerId)
        .select()
        .single()

      if (updateError) throw updateError

      // Update local state
      const index = players.value.findIndex(p => p.id === playerId)
      if (index !== -1) {
        players.value[index] = { ...players.value[index], ...data }
      }

      return data
    } catch (err) {
      error.value = err.message
      console.error('Error updating player:', err)
      throw err
    } finally {
      loading.value = false
    }
  }

  const deletePlayer = async (playerId) => {
    try {
      loading.value = true
      error.value = null

      const { data, error: deleteError } = await supabase
        .from('players')
        .update({ is_active: false })
        .eq('id', playerId)
        .select()
        .single()

      if (deleteError) throw deleteError

      // Remove from local state
      players.value = players.value.filter(p => p.id !== playerId)

      return data
    } catch (err) {
      error.value = err.message
      console.error('Error deleting player:', err)
      throw err
    } finally {
      loading.value = false
    }
  }

  const refreshPlayerData = async () => {
    try {
      await Promise.all([
        fetchPlayers(),
        fetchDashboardData(),
        fetchPlayerLogs()
      ])
    } catch (err) {
      console.error('Error refreshing player data:', err)
    }
  }

  // Real-time subscriptions
  const subscribeToPlayerUpdates = () => {
    return realtimeHelpers.subscribeToPlayerStatus((payload) => {
      console.log('Player status update:', payload)
      
      if (payload.eventType === 'UPDATE' && payload.new) {
        const index = players.value.findIndex(p => p.id === payload.new.id)
        if (index !== -1) {
          players.value[index] = { ...players.value[index], ...payload.new }
        }
      }
    })
  }

  const subscribeToPlayerLogs = () => {
    return realtimeHelpers.subscribeToPlayerLogs((payload) => {
      console.log('New player log:', payload)
      
      if (payload.eventType === 'INSERT') {
        playerLogs.value.unshift(payload.new)
        
        // Keep only the last 100 logs
        if (playerLogs.value.length > 100) {
          playerLogs.value = playerLogs.value.slice(0, 100)
        }
      }
    })
  }

  // Initialize store
  const init = async () => {
    try {
      await refreshPlayerData()
      
      // Set up real-time subscriptions
      subscribeToPlayerUpdates()
      subscribeToPlayerLogs()
    } catch (err) {
      console.error('Error initializing players store:', err)
    }
  }

  // Clear error
  const clearError = () => {
    error.value = null
  }

  return {
    // State
    players,
    playerStatistics,
    playerLogs,
    dashboardData,
    loading,
    error,
    
    // Computed
    onlinePlayers,
    offlinePlayers,
    unstablePlayers,
    totalPlayers,
    onlineCount,
    offlineCount,
    unstableCount,
    
    // Actions
    fetchPlayers,
    fetchPlayer,
    fetchDashboardData,
    fetchPlayerLogs,
    updatePlayerStatus,
    createPlayer,
    updatePlayer,
    deletePlayer,
    refreshPlayerData,
    subscribeToPlayerUpdates,
    subscribeToPlayerLogs,
    init,
    clearError
  }
})
