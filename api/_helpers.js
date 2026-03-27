import { createClient } from '@supabase/supabase-js'

const SUPABASE_URL = process.env.SUPABASE_URL
const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY

const FREE_LIMITS = { summary: 5, gap: 2, schematic: 3, weekly: 2 }

const corsHeaders = {
  'Content-Type': 'application/json',
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
}

export async function callClaude(prompt, maxTokens = 1500) {
  const key = process.env.ANTHROPIC_API_KEY
  if (!key) throw new Error('Server misconfigured')
  const r = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'x-api-key': key, 'anthropic-version': '2023-06-01' },
    body: JSON.stringify({ model: 'claude-sonnet-4-20250514', max_tokens: maxTokens, messages: [{ role: 'user', content: prompt }] }),
  })
  if (!r.ok) { const e = await r.json().catch(() => ({})); throw new Error(e.error?.message || 'Claude API error ' + r.status) }
  const d = await r.json()
  return (d.content || []).map(b => b.text || '').join('').replace(/```json/g, '').replace(/```/g, '').trim()
}

export async function callClaudeWithDoc(content, maxTokens = 1500) {
  const key = process.env.ANTHROPIC_API_KEY
  if (!key) throw new Error('Server misconfigured')
  const r = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'x-api-key': key, 'anthropic-version': '2023-06-01' },
    body: JSON.stringify({ model: 'claude-sonnet-4-20250514', max_tokens: maxTokens, messages: [{ role: 'user', content }] }),
  })
  if (!r.ok) { const e = await r.json().catch(() => ({})); throw new Error(e.error?.message || 'Claude API error ' + r.status) }
  const d = await r.json()
  return (d.content || []).map(b => b.text || '').join('').replace(/```json/g, '').replace(/```/g, '').trim()
}

async function verifyAndGetUsage(token) {
  if (!SUPABASE_URL || !SUPABASE_ANON_KEY) throw new Error('Server misconfigured — missing Supabase config')
  const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
    global: { headers: { Authorization: 'Bearer ' + token } }
  })
  const { data: userData, error: userError } = await supabase.auth.getUser(token)
  if (userError || !userData?.user) throw new Error('Not authenticated')
  const { data: usage, error: usageError } = await supabase.from('usage').select('*').eq('user_id', userData.user.id).single()
  if (usageError || !usage) throw new Error('Could not load usage data')
  return { user: userData.user, usage, supabase }
}

function checkLimit(usage, actionType) {
  if (usage.tier === 'pro') return true
  const countField = actionType + '_count'
  const current = usage[countField] || 0
  const limit = FREE_LIMITS[actionType]
  if (limit !== undefined && current >= limit) {
    throw new Error('Free tier limit reached (' + current + '/' + limit + ' ' + actionType + 's). Upgrade to Pro for unlimited access.')
  }
  return true
}

async function incrementUsage(supabase, userId, actionType) {
  const countField = actionType + '_count'
  const { data: current } = await supabase.from('usage').select(countField).eq('user_id', userId).single()
  const newCount = ((current && current[countField]) || 0) + 1
  await supabase.from('usage').update({ [countField]: newCount, updated_at: new Date().toISOString() }).eq('user_id', userId)
}

// Edge Runtime handler — gets 30s timeout on Vercel free plan (vs 10s for serverless)
export function edgeHandler(actionType, fn) {
  return async (req) => {
    if (req.method === 'OPTIONS') {
      return new Response(null, { status: 200, headers: corsHeaders })
    }
    if (req.method !== 'POST') {
      return new Response(JSON.stringify({ error: 'Method not allowed' }), { status: 405, headers: corsHeaders })
    }
    try {
      const authHeader = req.headers.get('authorization') || ''
      const token = authHeader.replace('Bearer ', '').trim()
      if (!token) throw new Error('Login required. Please sign in to use AI features.')

      const { user, usage, supabase } = await verifyAndGetUsage(token)
      checkLimit(usage, actionType)

      const body = await req.json()
      const result = await fn(body)

      await incrementUsage(supabase, user.id, actionType)

      return new Response(JSON.stringify(result), { status: 200, headers: corsHeaders })
    } catch (err) {
      console.error('API error:', err.message)
      const status = err.message.includes('Not authenticated') || err.message.includes('Login required') ? 401
        : err.message.includes('limit reached') ? 403 : 500
      return new Response(JSON.stringify({ error: err.message }), { status, headers: corsHeaders })
    }
  }
}
