export const config = { runtime: 'edge' }

export default async function handler(req) {
  const cors = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
  }

  const results = {
    runtime: 'edge',
    timestamp: new Date().toISOString(),
    env_check: {
      has_anthropic_key: !!process.env.ANTHROPIC_API_KEY,
      key_prefix: process.env.ANTHROPIC_API_KEY ? process.env.ANTHROPIC_API_KEY.slice(0, 10) + '...' : 'MISSING',
      has_supabase_url: !!process.env.SUPABASE_URL,
      has_supabase_anon: !!process.env.SUPABASE_ANON_KEY,
    },
    claude_test: null,
  }

  // Quick Claude API test (simple prompt, low tokens)
  try {
    const key = process.env.ANTHROPIC_API_KEY
    if (!key) {
      results.claude_test = { status: 'FAIL', error: 'No API key' }
    } else {
      const start = Date.now()
      const r = await fetch('https://api.anthropic.com/v1/messages', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'x-api-key': key, 'anthropic-version': '2023-06-01' },
        body: JSON.stringify({ model: 'claude-sonnet-4-20250514', max_tokens: 10, messages: [{ role: 'user', content: 'Say "ok"' }] }),
      })
      const elapsed = Date.now() - start
      if (r.ok) {
        const d = await r.json()
        results.claude_test = { status: 'OK', elapsed_ms: elapsed, response: d.content?.[0]?.text }
      } else {
        const e = await r.json().catch(() => ({}))
        results.claude_test = { status: 'FAIL', http_status: r.status, error: e.error?.message || 'Unknown', elapsed_ms: elapsed }
      }
    }
  } catch (e) {
    results.claude_test = { status: 'ERROR', error: e.message }
  }

  return new Response(JSON.stringify(results, null, 2), { status: 200, headers: cors })
}
