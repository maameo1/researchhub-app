import { handler } from './_helpers.js'

export default handler('summary', async (body) => {
  const { pdfBase64 } = body
  if (!pdfBase64) throw new Error('PDF data required')
  const key = process.env.ANTHROPIC_API_KEY
  if (!key) throw new Error('Server misconfigured')
  const r = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'x-api-key': key, 'anthropic-version': '2023-06-01' },
    body: JSON.stringify({ model: 'claude-sonnet-4-20250514', max_tokens: 1000, messages: [{ role: 'user', content: [{ type: 'document', source: { type: 'base64', media_type: 'application/pdf', data: pdfBase64 } }, { type: 'text', text: 'Return ONLY JSON: {"title":"...","authors":["..."],"abstract":"...","published":"YYYY","venue":"..."}' }] }] })
  })
  if (!r.ok) { const e = await r.json().catch(() => ({})); throw new Error(e.error?.message || 'PDF extraction failed') }
  const d = await r.json()
  const txt = (d.content || []).map(b => b.text || '').join('').replace(/```json|```/g, '').trim()
  return { metadata: JSON.parse(txt) }
})
