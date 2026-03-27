export const config = { runtime: 'edge' }

import { callClaude, edgeHandler } from './_helpers.js'

export default edgeHandler('weekly', async (body) => {
  const { readRecently, unread, allTags } = body
  const txt = await callClaude(`You are a PhD research reading advisor. Suggest a focused weekly reading plan.
RECENTLY READ (${(readRecently || []).length}):
${(readRecently || []).map(p => '- "' + p.title + '" [' + (p.tags || []).join(', ') + ']').join('\n')}
UNREAD (${(unread || []).length}):
${(unread || []).slice(0, 20).map(p => '- "' + p.title + '" [' + (p.tags || []).join(', ') + '] ' + (p.tldr || '')).join('\n')}
ALL TAGS: ${(allTags || []).join(', ')}
Return ONLY valid JSON:
{"from_library":[{"title":"exact title","reason":"why","priority":"high/medium"}],"new_suggestions":[{"search_query":"query","topic":"topic","reason":"why"}],"theme_of_the_week":"theme","reading_order_tip":"tip"}`, 1500)
  return { weekly: JSON.parse(txt) }
})
