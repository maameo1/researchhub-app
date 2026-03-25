import { callClaude, handler } from './_helpers.js'

export default handler(async (body) => {
  const { readRecently, unread, allTags } = body

  const prompt = `You are a PhD research reading advisor. Based on this researcher's library, suggest a focused weekly reading plan.

RECENTLY READ (${(readRecently || []).length}):
${(readRecently || []).map(p => '- "' + p.title + '" [Tags: ' + (p.tags || []).join(', ') + ']').join('\n')}

UNREAD IN LIBRARY (${(unread || []).length}):
${(unread || []).slice(0, 20).map(p => '- "' + p.title + '" [Tags: ' + (p.tags || []).join(', ') + '] TLDR: ' + (p.tldr || 'N/A')).join('\n')}

ALL TAGS: ${(allTags || []).join(', ')}

Return ONLY valid JSON:
{
  "from_library": [{"title":"exact paper title from unread list","reason":"why read this now, max 15 words","priority":"high/medium"}],
  "new_suggestions": [{"search_query":"specific search query for Semantic Scholar or PubMed","topic":"what gap this fills","reason":"why this matters for the researcher"}],
  "theme_of_the_week":"A 1-sentence theme to focus reading around",
  "reading_order_tip":"Brief advice on what order to read them in"
}

Rules:
- Pick 3-5 papers from the UNREAD list that form a coherent reading arc
- Suggest 2-3 new paper search queries for papers NOT in their library
- Base suggestions on what they've recently read and obvious gaps
- Priority "high" = foundational/prerequisite, "medium" = deepening understanding`

  const txt = await callClaude(prompt, 1500)
  return { weekly: JSON.parse(txt) }
})
