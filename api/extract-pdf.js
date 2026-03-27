export const config = { runtime: 'edge' }
import { callClaudeWithDoc, edgeHandler } from './_helpers.js'

export default edgeHandler('summary', async (body) => {
  const { pdfBase64 } = body
  if (!pdfBase64) throw new Error('PDF data required')
  const txt = await callClaudeWithDoc([
    { type: 'document', source: { type: 'base64', media_type: 'application/pdf', data: pdfBase64 } },
    { type: 'text', text: 'Return ONLY JSON: {"title":"...","authors":["..."],"abstract":"...","published":"YYYY","venue":"..."}' }
  ], 1000)
  return { metadata: JSON.parse(txt) }
})
