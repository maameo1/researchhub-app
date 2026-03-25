// Shared Claude API helper for all serverless functions
export async function callClaude(prompt, maxTokens = 1500) {
  const key = process.env.ANTHROPIC_API_KEY
  if (!key) throw new Error('Server misconfigured — missing API key')

  const r = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': key,
      'anthropic-version': '2023-06-01',
    },
    body: JSON.stringify({
      model: 'claude-sonnet-4-20250514',
      max_tokens: maxTokens,
      messages: [{ role: 'user', content: prompt }],
    }),
  })

  if (!r.ok) {
    const e = await r.json().catch(() => ({}))
    throw new Error(e.error?.message || 'Claude API error ' + r.status)
  }

  const d = await r.json()
  return (d.content || []).map(b => b.text || '').join('').replace(/```json/g, '').replace(/```/g, '').trim()
}

// CORS headers for browser requests
export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
}

// Standard handler wrapper
export function handler(fn) {
  return async (req, res) => {
    // Handle CORS preflight
    if (req.method === 'OPTIONS') {
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS')
      res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')
      return res.status(200).end()
    }

    if (req.method !== 'POST') {
      return res.status(405).json({ error: 'Method not allowed' })
    }

    // Set CORS headers
    Object.entries(corsHeaders).forEach(([k, v]) => res.setHeader(k, v))

    try {
      const result = await fn(req.body)
      return res.status(200).json(result)
    } catch (err) {
      console.error('API error:', err.message)
      return res.status(500).json({ error: err.message })
    }
  }
}
