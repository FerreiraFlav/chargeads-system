import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase, authHelpers, dbHelpers } from '@/config/supabase'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const userProfile = ref(null)
  const loading = ref(false)
  const error = ref(null)

  const isAuthenticated = computed(() => !!user.value)
  const isAdmin = computed(() => user.value?.role === 'admin')

  // Initialize auth state
  const init = async () => {
    try {
      loading.value = true
      
      console.log('Auth store init - getting session...')
      // Get current session
      const { data: { session }, error: sessionError } = await supabase.auth.getSession()
      
      console.log('Session:', session)
      console.log('Session error:', sessionError)
      
      if (session?.user) {
        console.log('Session user found, calling setUser')
        await setUser(session.user)
      } else {
        console.log('No session user found')
      }

      // Listen for auth changes
      supabase.auth.onAuthStateChange(async (event, session) => {
        console.log('Auth state changed:', event, session)
        if (session?.user) {
          await setUser(session.user)
        } else {
          clearUser()
        }
      })
    } catch (err) {
      error.value = err.message
      console.error('Auth initialization error:', err)
    } finally {
      loading.value = false
    }
  }

  // Set user data
  const setUser = async (authUser) => {
    try {
      console.log('setUser called with:', authUser)
      
      // Get user profile from our custom users table
      const { data: profile, error: profileError } = await supabase
        .from('users')
        .select(`
          *,
          user_profiles (*)
        `)
        .eq('id', authUser.id)
        .single()

      console.log('Profile from DB:', profile)
      console.log('Profile error:', profileError)

      if (profileError && profileError.code !== 'PGRST116') {
        throw profileError
      }

      user.value = {
        id: authUser.id,
        email: authUser.email,
        name: profile?.full_name || authUser.user_metadata?.full_name || authUser.email,
        role: profile?.role || 'user',
        avatar: profile?.avatar_url || authUser.user_metadata?.avatar_url,
        ...authUser
      }

      console.log('User set to:', user.value)

      userProfile.value = profile?.user_profiles || null

      // Update last login
      await supabase.rpc('update_last_login')

      // Store in localStorage for persistence
      localStorage.setItem('user', JSON.stringify(user.value))
    } catch (err) {
      error.value = err.message
      console.error('Error setting user:', err)
    }
  }

  // Clear user data
  const clearUser = () => {
    user.value = null
    userProfile.value = null
    localStorage.removeItem('user')
  }

  // Login with email and password
  const login = async (email, password) => {
    try {
      loading.value = true
      error.value = null

      console.log('Auth store login - calling authHelpers.signIn')
      const data = await authHelpers.signIn(email, password)
      
      console.log('SignIn returned data:', data)
      
      // Set user data after successful login
      if (data?.user) {
        console.log('Calling setUser with:', data.user)
        await setUser(data.user)
      } else {
        console.log('No user in returned data:', data)
      }

      return data
    } catch (err) {
      console.error('Auth store login error:', err)
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  // Logout
  const logout = async () => {
    try {
      loading.value = true
      
      // Log logout activity
      await supabase.rpc('handle_logout')
      
      // Sign out from Supabase
      await authHelpers.signOut()
      
      clearUser()
    } catch (err) {
      error.value = err.message
      console.error('Logout error:', err)
    } finally {
      loading.value = false
    }
  }

  // Register new user
  const register = async (email, password, metadata = {}) => {
    try {
      loading.value = true
      error.value = null

      const { data, error: authError } = await authHelpers.signUp(email, password, metadata)
      
      if (authError) throw authError

      return data
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  // Update user profile
  const updateProfile = async (updates) => {
    try {
      loading.value = true
      error.value = null

      const { data, error: updateError } = await supabase
        .from('users')
        .update(updates)
        .eq('id', user.value.id)
        .select()
        .single()

      if (updateError) throw updateError

      // Update local user data
      user.value = { ...user.value, ...data }
      localStorage.setItem('user', JSON.stringify(user.value))

      return data
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  // Update user preferences
  const updatePreferences = async (preferences) => {
    try {
      loading.value = true
      error.value = null

      const { data, error: updateError } = await supabase
        .from('user_profiles')
        .upsert({
          user_id: user.value.id,
          preferences
        })
        .select()
        .single()

      if (updateError) throw updateError

      userProfile.value = data
      return data
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  // Reset password
  const resetPassword = async (email) => {
    try {
      loading.value = true
      error.value = null

      const { data, error: resetError } = await authHelpers.resetPassword(email)
      
      if (resetError) throw resetError

      return data
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  // Change password
  const changePassword = async (newPassword) => {
    try {
      loading.value = true
      error.value = null

      const { data, error: changeError } = await authHelpers.updatePassword(newPassword)
      
      if (changeError) throw changeError

      return data
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  // Load user from localStorage (fallback)
  const loadUser = () => {
    const savedUser = localStorage.getItem('user')
    if (savedUser) {
      user.value = JSON.parse(savedUser)
    }
  }

  // Clear error
  const clearError = () => {
    error.value = null
  }

  return {
    // State
    user,
    userProfile,
    loading,
    error,
    
    // Computed
    isAuthenticated,
    isAdmin,
    
    // Actions
    init,
    login,
    logout,
    register,
    updateProfile,
    updatePreferences,
    resetPassword,
    changePassword,
    loadUser,
    clearError
  }
})
