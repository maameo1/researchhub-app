import { callClaude, handler } from './_helpers.js'

export default handler('summary', async (body) => {
  const { title, authors, abstract } = body
  if (!title) throw new Error('Title required')
  const txt = await callClaude(`Research paper analyst. Return ONLY JSON.
Title: ${title}\nAuthors: ${(authors || []).join(', ')}\nAbstract: ${abstract || 'N/A'}
For key_citations_to_follow provide REAL papers as "Author et al., Title (Year)".
{"tldr":"max 30 words","key_contributions":["..."],"methods":["..."],"limitations":["..."],"tags":["t1","t2","t3"],"relevance_to_medical_imaging":"One sentence.","key_citations_to_follow":[{"citation":"Author et al., Title (Year)","reason":"Why"}],"open_questions":["..."]}`, 1500)
  return { summary: JSON.parse(txt) }
})

