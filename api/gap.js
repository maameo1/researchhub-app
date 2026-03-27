export const config = { runtime: 'edge' }

import { callClaude, edgeHandler } from './_helpers.js'

export default edgeHandler('gap', async (body) => {
  const { papers } = body
  if (!papers || papers.length < 2) throw new Error('Need 2+ papers')
  const sm = papers.slice(0, 20).map((p, i) => {
    const s = p.summary
    const info = s ? ('TLDR: ' + (s.tldr || '') + '. Methods: ' + (s.methods || []).join(', '))
      : ('Abstract: ' + (p.abstract || 'N/A').slice(0, 200))
    return '[' + (i + 1) + '] "' + p.title + '" - ' + info
  }).join('\n')
  const txt = await callClaude('You are a research gap analyst. Analyze these ' + papers.length + ' papers.\n\n' + sm + '\n\nReturn ONLY valid JSON:\n{"themes":["..."],"gaps":["..."],"contradictions":["..."],"suggested_directions":["..."],"missing_baselines":["..."],"suggested_search_queries":["..."]}', 1200)
  return { gap: JSON.parse(txt) }
})
