// Storage keys
export const PK = 'rh_papers', AK = 'rh_api', ZUK = 'rh_zu', ZKK = 'rh_zk', GK = 'rh_gap'

export function gid() { return Date.now().toString(36) + Math.random().toString(36).slice(2, 8) }

// Tag colors
const TC = [{bg:'#1a2332',fg:'#7eb8da'},{bg:'#2a1a2e',fg:'#c490d1'},{bg:'#1a2e1a',fg:'#7ec47e'},{bg:'#2e2a1a',fg:'#d1c490'},{bg:'#1a2e2e',fg:'#7ec4c4'},{bg:'#2e1a1a',fg:'#d19090'}]
export function gtc(t){let h=0;for(let i=0;i<t.length;i++)h=((h<<5)-h+t.charCodeAt(i))|0;return TC[Math.abs(h)%TC.length]}
export function tagStyle(t){const c=gtc(t);return{display:'inline-block',padding:'2px 8px',borderRadius:3,fontSize:11,fontFamily:'var(--mono)',background:c.bg,color:c.fg,marginRight:6,marginBottom:4}}

// Storage
export function ld(k,d){try{const v=localStorage.getItem(k);return v?JSON.parse(v):d}catch{return d}}
export function sv(k,v){try{localStorage.setItem(k,typeof v==='string'?v:JSON.stringify(v))}catch{}}

// Paper URL helpers
export function getPaperUrl(p) {
  if (p.sourceId?.match(/^10\./)) return 'https://doi.org/' + p.sourceId
  if (p.sourceId?.match(/^\d{4}\.\d{4,5}/)) return 'https://arxiv.org/abs/' + p.sourceId
  if (p.url) return p.url
  return null
}
export function getPdfUrl(p) {
  if (p.sourceId?.match(/^\d{4}\.\d{4,5}/)) return 'https://arxiv.org/pdf/' + p.sourceId + '.pdf'
  if (p.pdfLink) return p.pdfLink
  return null
}

// ── Direct Claude API call (personal/self-hosted mode) ──────────────────
export async function callAI(key, prompt, mt) {
  if (!key) throw new Error('API key required. Add it in Settings.')
  const cleanKey = key.replace(/[^\x20-\x7E]/g, '').trim()
  if (!cleanKey) throw new Error('API key appears invalid. Re-enter it in Settings.')
  const r = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': cleanKey,
      'anthropic-version': '2023-06-01',
      'anthropic-dangerous-direct-browser-access': 'true',
    },
    body: JSON.stringify({ model: 'claude-sonnet-4-20250514', max_tokens: mt || 1500, messages: [{ role: 'user', content: prompt }] })
  })
  if (!r.ok) { const e = await r.json().catch(() => ({})); throw new Error(e.error?.message || 'API error ' + r.status) }
  const d = await r.json()
  return (d.content || []).map(b => b.text || '').join('').replace(/```json/g, '').replace(/```/g, '').trim()
}

// ── Server proxy call (deployed mode — no user API key needed) ──────────
async function proxyCall(endpoint, body) {
  let token = null
  try {
    const { getToken } = await import('./supabase.js')
    token = await getToken()
  } catch (e) {}
  if (!token) throw new Error('Please sign in to use AI features.')
  const r = await fetch('/api/' + endpoint, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token },
    body: JSON.stringify(body),
  })
  if (!r.ok) {
    const e = await r.json().catch(() => ({}))
    throw new Error(e.error || 'Server error ' + r.status)
  }
  return r.json()
}

// ── Summary — direct if key provided, proxy if not ──────────────────────
export async function genSummary(key, p) {
  if (key) {
    return JSON.parse(await callAI(key, `Research paper analyst. Return ONLY JSON.
Title: ${p.title}\nAuthors: ${(p.authors||[]).join(', ')}\nAbstract: ${p.abstract||'N/A'}
For key_citations_to_follow provide REAL papers as "Author et al., Title (Year)".
{"tldr":"max 30 words","key_contributions":["..."],"methods":["..."],"limitations":["..."],"tags":["t1","t2","t3"],"relevance_to_medical_imaging":"One sentence.","key_citations_to_follow":[{"citation":"Author et al., Title (Year)","reason":"Why"}],"open_questions":["..."]}`, 1500))
  }
  const result = await proxyCall('summarize', { title: p.title, authors: p.authors, abstract: p.abstract })
  return result.summary
}

// ── Gap analysis ────────────────────────────────────────────────────────
export async function genGap(key, papers) {
  if (key) {
    const sm = papers.slice(0, 20).map((p, i) => {
      const s = p.summary
      const info = s ? ('TLDR: ' + (s.tldr || '') + '. Methods: ' + (s.methods || []).join(', '))
        : ('Abstract: ' + (p.abstract || 'N/A').slice(0, 200))
      return '[' + (i + 1) + '] "' + p.title + '" - ' + info
    }).join('\n')
    return JSON.parse(await callAI(key, 'You are a research gap analyst. Analyze these ' + papers.length + ' papers.\n\n' + sm + '\n\nReturn ONLY valid JSON:\n{"themes":["..."],"gaps":["..."],"contradictions":["..."],"suggested_directions":["..."],"missing_baselines":["..."],"suggested_search_queries":["..."]}', 1200))
  }
  const result = await proxyCall('gap', { papers: papers.slice(0, 20).map(p => ({ title: p.title, abstract: p.abstract, summary: p.summary })) })
  return result.gap
}

// ── Weekly reading suggestions ──────────────────────────────────────────
export async function genWeeklyRecs(key, papers) {
  const readRecently = papers.filter(p => p.readStatus === 'read').slice(0, 5)
  const unread = papers.filter(p => p.readStatus !== 'read')
  const allTagsList = [...new Set(papers.flatMap(p => p.summary?.tags || []))]
  if (key) {
    const prompt = `You are a PhD research reading advisor. Suggest a focused weekly reading plan.
RECENTLY READ (${readRecently.length}):
${readRecently.map(p => '- "' + p.title + '" [' + (p.summary?.tags || []).join(', ') + ']').join('\n')}
UNREAD (${unread.length}):
${unread.slice(0, 20).map(p => '- "' + p.title + '" [' + (p.summary?.tags || []).join(', ') + '] ' + (p.summary?.tldr || p.abstract?.slice(0, 80) || 'N/A')).join('\n')}
ALL TAGS: ${allTagsList.join(', ')}
Return ONLY valid JSON:
{"from_library":[{"title":"exact title","reason":"why","priority":"high/medium"}],"new_suggestions":[{"search_query":"query","topic":"topic","reason":"why"}],"theme_of_the_week":"theme","reading_order_tip":"tip"}
Rules: Pick 3-5 from UNREAD. Suggest 2-3 new search queries. Priority high=foundational, medium=deepening.`
    return JSON.parse(await callAI(key, prompt, 1500))
  }
  const result = await proxyCall('weekly', {
    readRecently: readRecently.map(p => ({ title: p.title, tags: p.summary?.tags })),
    unread: unread.slice(0, 20).map(p => ({ title: p.title, tags: p.summary?.tags, tldr: p.summary?.tldr })),
    allTags: allTagsList,
  })
  return result.weekly
}

// ── PDF extraction ──────────────────────────────────────────────────────
export async function extractPdf(key, b64) {
  if (key) {
    const resp = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'x-api-key': key, 'anthropic-version': '2023-06-01', 'anthropic-dangerous-direct-browser-access': 'true' },
      body: JSON.stringify({ model: 'claude-sonnet-4-20250514', max_tokens: 1000, messages: [{ role: 'user', content: [{ type: 'document', source: { type: 'base64', media_type: 'application/pdf', data: b64 } }, { type: 'text', text: 'Return ONLY JSON: {"title":"...","authors":["..."],"abstract":"...","published":"YYYY","venue":"..."}' }] }] })
    })
    if (!resp.ok) throw new Error('PDF extraction failed')
    return JSON.parse((await resp.json()).content?.map(b => b.text || '').join('').replace(/```json|```/g, '').trim())
  }
  const result = await proxyCall('extract-pdf', { pdfBase64: b64 })
  return result.metadata
}

// ── Schematic generation ────────────────────────────────────────────────
export async function genSchematic(key, p) {
  const prompt = `You are an expert scientific diagram designer. Create a CLEAN, PROFESSIONAL SVG pipeline diagram.
Title: ${p.title}
Abstract: ${p.abstract || 'N/A'}
Methods: ${p.summary?.methods?.join(', ') || 'N/A'}
Key contributions: ${p.summary?.key_contributions?.join(', ') || 'N/A'}
RULES:
1. Return ONLY raw SVG. No markdown, no backticks.
2. <svg viewBox="0 0 700 350" xmlns="http://www.w3.org/2000/svg">
3. LEFT-TO-RIGHT flow, 3-6 stages.
4. BOXES: <rect> rx="8" ry="8" width 100-130 height 50-65.
5. COLORS: Input fill="#1a3329" stroke="#5b8a72", Processing fill="#1a2535" stroke="#7eb8da", Key fill="#251a35" stroke="#9070c4", Output fill="#2e2a1a" stroke="#d1c490"
6. TEXT: fill="#e8e8e8" font-family="Arial,sans-serif" labels font-size="12" bold
7. ARROWS: stroke="#4a5a6a" stroke-width="2" with arrowhead in <defs>
8. BACKGROUND: <rect width="700" height="350" fill="#0e1318" rx="8"/>
9. Center boxes around y=160.`
  if (key) return (await callAI(key, prompt, 3000)).trim()
  const result = await proxyCall('schematic', { title: p.title, abstract: p.abstract, methods: p.summary?.methods?.join(', '), contributions: p.summary?.key_contributions?.join(', ') })
  return result.schematic
}

// ── BibTeX parser (unchanged) ───────────────────────────────────────────
export function parseBib(text) {
  const entries = []
  text.split(/\n@/).map((b, i) => i === 0 ? b : '@' + b).forEach(block => {
    if (!block.match(/@\w+\{/)) return
    const g = (k) => { const m = block.match(new RegExp(k + '\\s*=\\s*[{"]([\\s\\S]*?)[}"]', 'i')); return m ? m[1].replace(/[{}]/g, '').replace(/\s+/g, ' ').trim() : '' }
    const t = g('title'); if (!t) return
    const a = g('author')
    entries.push({ title: t, authors: a ? a.split(' and ').map(x => { const p = x.trim().split(','); return p.length > 1 ? p[1].trim() + ' ' + p[0].trim() : x.trim() }) : [], abstract: g('abstract'), published: g('year') || g('date') || '', venue: g('journal') || g('booktitle') || '', source: 'BibTeX', sourceId: g('doi') || t.slice(0, 30) })
  })
  return entries
}

// ── CSV parser (unchanged) ──────────────────────────────────────────────
export function parseCsv(text) {
  const l = text.split('\n'); if (l.length < 2) return []
  const h = l[0].split(',').map(x => x.trim().replace(/^"|"$/g, '').toLowerCase())
  const ti = h.findIndex(x => x.includes('title')); if (ti === -1) return []
  const ai = h.findIndex(x => ['author', 'authors', 'creator'].includes(x))
  const ab = h.findIndex(x => x.includes('abstract'))
  const yi = h.findIndex(x => ['year', 'date'].includes(x) || x.includes('publication'))
  const vi = h.findIndex(x => x === 'journal' || x.includes('publication title'))
  const di = h.findIndex(x => x === 'doi')
  const entries = []
  for (let i = 1; i < l.length; i++) {
    if (!l[i].trim()) continue
    const c = []; let cur = '', inQ = false
    for (const ch of l[i]) { if (ch === '"') inQ = !inQ; else if (ch === ',' && !inQ) { c.push(cur.trim()); cur = '' } else cur += ch }
    c.push(cur.trim())
    const t = c[ti]?.replace(/^"|"$/g, ''); if (!t) continue
    const ar = ai >= 0 ? c[ai]?.replace(/^"|"$/g, '') || '' : ''
    entries.push({ title: t, authors: ar ? ar.split(';').map(a => a.trim()).filter(Boolean) : [], abstract: ab >= 0 ? c[ab]?.replace(/^"|"$/g, '') || '' : '', published: yi >= 0 ? c[yi]?.replace(/^"|"$/g, '') || '' : '', venue: vi >= 0 ? c[vi]?.replace(/^"|"$/g, '') || '' : '', source: 'CSV', sourceId: di >= 0 ? c[di]?.replace(/^"|"$/g, '') || t.slice(0, 30) : t.slice(0, 30) })
  }
  return entries
}

// ── Relationships (unchanged) ───────────────────────────────────────────
export function computeRelationships(papers) {
  const rels = []
  const stopwords = new Set(['a','an','the','of','for','and','in','on','with','to','from','by','using','based','deep','learning','network','method','model','image','segmentation','analysis','approach'])
  for (let i = 0; i < papers.length; i++) {
    for (let j = i + 1; j < papers.length; j++) {
      const a = papers[i], b = papers[j], reasons = []
      const aTags = new Set(a.summary?.tags || [])
      const shared = (b.summary?.tags || []).filter(t => aTags.has(t))
      if (shared.length > 0) reasons.push('Tags: ' + shared.join(', '))
      const aM = new Set((a.summary?.methods || []).map(m => m.toLowerCase()))
      const shM = (b.summary?.methods || []).filter(m => aM.has(m.toLowerCase()))
      if (shM.length > 0) reasons.push('Methods: ' + shM.join(', '))
      const aA = new Set((a.authors || []).map(x => x.toLowerCase()))
      const shA = (b.authors || []).filter(x => aA.has(x.toLowerCase()))
      if (shA.length > 0) reasons.push('Authors: ' + shA.join(', '))
      const aW = new Set((a.title || '').toLowerCase().split(/\W+/).filter(w => w.length > 3 && !stopwords.has(w)))
      const shW = (b.title || '').toLowerCase().split(/\W+/).filter(w => w.length > 3 && !stopwords.has(w) && aW.has(w))
      if (shW.length >= 2) reasons.push('Keywords: ' + shW.slice(0, 4).join(', '))
      if (reasons.length > 0) rels.push({ a: a.id, b: b.id, aTitle: a.title, bTitle: b.title, reasons, strength: reasons.length })
    }
  }
  return rels.sort((a, b) => b.strength - a.strength)
}

export function computeClusters(papers, rels) {
  if (!papers.length) return []
  const parent = {}
  papers.forEach(p => { parent[p.id] = p.id })
  function find(x) { while (parent[x] !== x) { parent[x] = parent[parent[x]]; x = parent[x] } return x }
  function union(a, b) { const ra = find(a), rb = find(b); if (ra !== rb) parent[ra] = rb }
  for (const r of rels) { if (r.strength >= 1) union(r.a, r.b) }
  const groups = {}
  for (const p of papers) { const root = find(p.id); if (!groups[root]) groups[root] = []; groups[root].push(p) }
  const clusters = Object.values(groups).filter(g => g.length >= 2).map(group => {
    const tagCounts = {}; group.forEach(p => (p.summary?.tags || []).forEach(t => { tagCounts[t] = (tagCounts[t] || 0) + 1 }))
    const topTags = Object.entries(tagCounts).sort((a, b) => b[1] - a[1]).slice(0, 3).map(e => e[0])
    const methodCounts = {}; group.forEach(p => (p.summary?.methods || []).forEach(m => { const k = m.toLowerCase(); methodCounts[k] = (methodCounts[k] || 0) + 1 }))
    const topMethods = Object.entries(methodCounts).sort((a, b) => b[1] - a[1]).slice(0, 2).map(e => e[0])
    const nameParts = topTags.length > 0 ? topTags.slice(0, 2) : topMethods.slice(0, 2)
    const name = nameParts.length > 0 ? nameParts.join(' + ') : 'Group of ' + group.length + ' papers'
    const groupIds = new Set(group.map(p => p.id))
    const internalRels = rels.filter(r => groupIds.has(r.a) && groupIds.has(r.b))
    const allReasons = new Set(); internalRels.forEach(r => r.reasons.forEach(reason => allReasons.add(reason)))
    return { name, papers: group, tags: topTags, methods: topMethods, reasons: [...allReasons].slice(0, 6), size: group.length }
  }).sort((a, b) => b.size - a.size)
  const bridges = []
  for (const p of papers) {
    const connectedClusters = new Set()
    for (const r of rels) { if (r.a === p.id || r.b === p.id) { const otherId = r.a === p.id ? r.b : r.a; const otherCluster = clusters.findIndex(c => c.papers.some(cp => cp.id === otherId)); if (otherCluster >= 0) connectedClusters.add(otherCluster) } }
    if (connectedClusters.size >= 2) bridges.push({ paper: p, clusters: [...connectedClusters].map(i => clusters[i]?.name || 'Unknown') })
  }
  return { clusters, bridges }
}
