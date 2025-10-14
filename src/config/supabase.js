import { createClient } from '@supabase/supabase-js'

// Supabase configuration
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://fpafzaxqvudzppabaqum.supabase.co'
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZwYWZ6YXhxdnVkenBwYWJhcXVtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAyOTczMDMsImV4cCI6MjA3NTg3MzMwM30.PjsRDey8OncpdxvZCGLhQCy0uGurFqa0pc6-A6x12xg'

// Create Supabase client
export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true
  }
})

// Database table names
export const TABLES = {
  USERS: 'users',
  USER_PROFILES: 'user_profiles',
  PLAYERS: 'players',
  PLAYER_STATISTICS: 'player_statistics',
  PLAYER_LOGS: 'player_logs',
  SYSTEM_SETTINGS: 'system_settings',
  AUDIT_LOGS: 'audit_logs'
}

// Auth configuration
export const AUTH_CONFIG = {
  signUpOptions: {
    emailRedirectTo: `${window.location.origin}/dashboard`
  },
  signInOptions: {
    emailRedirectTo: `${window.location.origin}/dashboard`
  }
}

// Helper functions
export const authHelpers = {
  // Get current user
  async getCurrentUser() {
    const { data: { user }, error } = await supabase.auth.getUser()
    if (error) throw error
    return user
  },

  // Get current session
  async getCurrentSession() {
    const { data: { session }, error } = await supabase.auth.getSession()
    if (error) throw error
    return session
  },

  // Sign in with email and password
  async signIn(email, password) {
    console.log('authHelpers.signIn called with:', email)
    try {
      const result = await supabase.auth.signInWithPassword({
        email,
        password
      })
      console.log('Supabase signInWithPassword result:', result)
      const { data, error } = result
      console.log('Data from result:', data)
      console.log('Error from result:', error)
      if (error) {
        console.log('Throwing error:', error)
        throw error
      }
      console.log('Returning data:', data)
      return data
    } catch (err) {
      console.error('authHelpers.signIn error:', err)
      throw err
    }
  },

  // Sign up with email and password
  async signUp(email, password, metadata = {}) {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: metadata
      }
    })
    if (error) throw error
    return data
  },

  // Sign out
  async signOut() {
    const { error } = await supabase.auth.signOut()
    if (error) throw error
  },

  // Reset password
  async resetPassword(email) {
    const { data, error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/reset-password`
    })
    if (error) throw error
    return data
  },

  // Update password
  async updatePassword(newPassword) {
    const { data, error } = await supabase.auth.updateUser({
      password: newPassword
    })
    if (error) throw error
    return data
  }
}

// Database helper functions
export const dbHelpers = {
  // Get user profile
  async getUserProfile(userId = null) {
    const targetUserId = userId || (await authHelpers.getCurrentUser())?.id
    if (!targetUserId) throw new Error('No user ID provided')

    const { data, error } = await supabase
      .from(TABLES.USERS)
      .select(`
        *,
        user_profiles (*)
      `)
      .eq('id', targetUserId)
      .single()

    if (error) throw error
    return data
  },

  // Update user profile
  async updateUserProfile(updates) {
    const { data, error } = await supabase
      .from(TABLES.USERS)
      .update(updates)
      .eq('id', (await authHelpers.getCurrentUser()).id)
      .select()
      .single()

    if (error) throw error
    return data
  },

  // Get all players
  async getPlayers() {
    const { data, error } = await supabase
      .from(TABLES.PLAYERS)
      .select(`
        *,
        player_statistics (*)
      `)
      .eq('is_active', true)
      .order('name')

    if (error) throw error
    return data
  },

  // Get player by ID
  async getPlayer(playerId) {
    const { data, error } = await supabase
      .from(TABLES.PLAYERS)
      .select(`
        *,
        player_statistics (*)
      `)
      .eq('id', playerId)
      .single()

    if (error) throw error
    return data
  },

  // Update player status
  async updatePlayerStatus(playerId, status, message = null, responseTime = null) {
    const { data, error } = await supabase.rpc('update_player_status', {
      p_player_id: playerId,
      p_status: status,
      p_message: message,
      p_response_time: responseTime
    })

    if (error) throw error
    return data
  },

  // Get player dashboard data
  async getPlayerDashboard() {
    const { data, error } = await supabase.rpc('get_player_dashboard')

    if (error) throw error
    return data[0] // Function returns table, so we get first row
  },

  // Get recent player logs
  async getRecentPlayerLogs(limit = 50) {
    const { data, error } = await supabase
      .from(TABLES.PLAYER_LOGS)
      .select(`
        *,
        players (name)
      `)
      .order('created_at', { ascending: false })
      .limit(limit)

    if (error) throw error
    return data
  },

  // Get system settings
  async getSystemSettings(publicOnly = false) {
    let query = supabase.from(TABLES.SYSTEM_SETTINGS).select('*')
    
    if (publicOnly) {
      query = query.eq('is_public', true)
    }

    const { data, error } = await query.order('key')

    if (error) throw error
    return data
  },

  // Update system setting
  async updateSystemSetting(key, value, description = null) {
    const { data, error } = await supabase
      .from(TABLES.SYSTEM_SETTINGS)
      .upsert({
        key,
        value,
        description
      })
      .select()
      .single()

    if (error) throw error
    return data
  },

  // Log user activity
  async logActivity(action, resourceType = null, resourceId = null, details = null) {
    const { data, error } = await supabase.rpc('log_user_activity', {
      p_action: action,
      p_resource_type: resourceType,
      p_resource_id: resourceId,
      p_details: details
    })

    if (error) throw error
    return data
  }
}

// Real-time subscriptions
export const realtimeHelpers = {
  // Subscribe to player status changes
  subscribeToPlayerStatus(callback) {
    return supabase
      .channel('player-status-changes')
      .on('postgres_changes', {
        event: '*',
        schema: 'public',
        table: TABLES.PLAYERS
      }, callback)
      .subscribe()
  },

  // Subscribe to player logs
  subscribeToPlayerLogs(callback) {
    return supabase
      .channel('player-logs')
      .on('postgres_changes', {
        event: 'INSERT',
        schema: 'public',
        table: TABLES.PLAYER_LOGS
      }, callback)
      .subscribe()
  },

  // Subscribe to user activity
  subscribeToUserActivity(callback) {
    return supabase
      .channel('user-activity')
      .on('postgres_changes', {
        event: 'INSERT',
        schema: 'public',
        table: TABLES.AUDIT_LOGS
      }, callback)
      .subscribe()
  }
}

// Export default
export default supabase
