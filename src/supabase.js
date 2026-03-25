import { createClient } from '@supabase/supabase-js'

const SUPABASE_URL = 'https://tjdopwduztdzqvzispmp.supabase.co'
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRqZG9wd2R1enRkenF2emlzcG1wIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzODYzMzAsImV4cCI6MjA4OTk2MjMzMH0.EoDPDW5EShkXIPOUnc_IRztvR8aR92yM6wUk1S0vDGE'

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)

// Get current session token
export async function getToken() {
  const { data } = await supabase.auth.getSession()
  return data?.session?.access_token || null
}

// Get current user
export async function getUser() {
  const { data } = await supabase.auth.getUser()
  return data?.user || null
}

// Sign up
export async function signUp(email, password) {
  const { data, error } = await supabase.auth.signUp({ email, password })
  if (error) throw error
  return data
}

// Sign in
export async function signIn(email, password) {
  const { data, error } = await supabase.auth.signInWithPassword({ email, password })
  if (error) throw error
  return data
}

// Sign out — use local scope to avoid network dependency
export async function signOut() {
  try {
    await supabase.auth.signOut({ scope: 'local' })
  } catch {}
  // Force clear all auth storage regardless
  try {
    Object.keys(localStorage).forEach(k => {
      if (k.includes('supabase') || k.includes('sb-') || k.includes('auth-token')) {
        localStorage.removeItem(k)
      }
    })
  } catch {}
}

// Get usage for current user
export async function getUsage() {
  const { data, error } = await supabase.from('usage').select('*').single()
  if (error) return null
  return data
}

// Free tier limits
export const FREE_LIMITS = {
  summaries: 5,
  gaps: 2,
  schematics: 3,
  weekly: 2,
}
