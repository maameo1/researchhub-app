import { callClaude, handler } from './_helpers.js'

export default handler(async (body) => {
  const { papers } = body
  if (!papers || papers.length < 2) throw new Error('Need 2+ papers')

  const sm = papers.slice(0, 20).map((p, i) => {
    const s = p.summary
    const info = s ? ('TLDR: ' + (s.tldr || '') + '. Methods: ' + (s.methods || []).join(', ') + '. Limitations: ' + (s.limitations || []).join(', '))
      : ('Abstract: ' + (p.abstract || 'N/A').slice(0, 200))
    return '[' + (i + 1) + '] "' + p.title + '" - ' + info
  }).join('\n')

  const txt = await callClaude('You are a research gap analyst. Analyze these ' + papers.length + ' papers and identify research gaps.\n\n' + sm + '\n\nReturn ONLY valid JSON with no other text:\n{"themes":["theme1","theme2"],"gaps":["specific gap 1","specific gap 2"],"contradictions":["contradiction if any"],"suggested_directions":["direction 1","direction 2"],"missing_baselines":["missing comparison 1"],"suggested_search_queries":["arxiv query to fill gap 1"]}', 1200)

  return { gap: JSON.parse(txt) }
})
