#!/bin/bash
echo "=== ResearchHub Clean Setup ==="
if [ ! -d ".git" ]; then echo "ERROR: Run from repo root"; exit 1; fi
echo "Cleaning..."
rm -rf src/ api/ public/
rm -f vercel.json package.json vite.config.js index.html .gitignore README.md
mkdir -p src/components api public

echo 'Creating vercel.json...'
cat > vercel.json << 'ENDFILE_vercel_json'
{"framework":"vite"}

ENDFILE_vercel_json

echo 'Creating .gitignore...'
cat > .gitignore << 'ENDFILE__gitignore'
node_modules
dist
.env
.DS_Store

ENDFILE__gitignore

echo 'Creating package.json...'
cat > package.json << 'ENDFILE_package_json'
{
  "name": "researchhub-app",
  "version": "1.0.0",
  "description": "AI-powered literature review and research intelligence tool",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "@supabase/supabase-js": "^2.45.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.2.1",
    "vite": "^5.4.0"
  }
}

ENDFILE_package_json

echo 'Creating vite.config.js...'
cat > vite.config.js << 'ENDFILE_vite_config_js'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    open: true
  }
})

ENDFILE_vite_config_js

echo 'Creating index.html...'
cat > index.html << 'ENDFILE_index_html'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>ResearchHub — AI Literature Intelligence</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>◇</text></svg>">
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>

ENDFILE_index_html

echo 'Creating src/main.jsx...'
cat > src/main.jsx << 'ENDFILE_src_main_jsx'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
)

ENDFILE_src_main_jsx

echo 'Creating src/index.css...'
cat > src/index.css << 'ENDFILE_src_index_css'
@import url('https://fonts.googleapis.com/css2?family=Instrument+Serif:ital@0;1&display=swap');

* { margin: 0; padding: 0; box-sizing: border-box; }

:root {
  --bg-primary: #0b0f14;
  --bg-secondary: #111822;
  --bg-tertiary: #0f1520;
  --border: #1a2535;
  --border-hover: #2a4a39;
  --text-primary: #e8e8e8;
  --text-secondary: #d4d4d4;
  --text-muted: #6a7b8f;
  --text-faint: #4a5a6a;
  --accent-green: #5b8a72;
  --accent-green-light: #7ec49e;
  --accent-blue: #7eb8da;
  --accent-purple: #9070c4;
  --accent-orange: #c49070;
  --accent-yellow: #c4c470;
  --accent-red: #c47070;
  --mono: 'SF Mono', 'Fira Code', 'Cascadia Code', monospace;
  --serif: 'Instrument Serif', Georgia, serif;
}

body {
  font-family: var(--serif);
  background: var(--bg-primary);
  color: var(--text-secondary);
  min-height: 100vh;
  -webkit-font-smoothing: antialiased;
}

a { color: inherit; }

::selection {
  background: rgba(91, 138, 114, 0.3);
  color: var(--text-primary);
}

::-webkit-scrollbar { width: 6px; }
::-webkit-scrollbar-track { background: var(--bg-primary); }
::-webkit-scrollbar-thumb { background: #1a2535; border-radius: 3px; }
::-webkit-scrollbar-thumb:hover { background: #2a3545; }

textarea:focus, input:focus { border-color: var(--accent-green) !important; }

.btn-primary {
  padding: 10px 18px; background: #1a3329; color: var(--accent-green-light);
  border: 1px solid #2a4a39; border-radius: 6px; cursor: pointer;
  font-size: 13px; font-family: var(--mono); font-weight: 500; white-space: nowrap;
  transition: background 0.15s;
}
.btn-primary:hover { background: #1e3d30; }
.btn-primary:disabled { opacity: 0.5; cursor: default; }

.btn-sec {
  padding: 10px 18px; background: #161d28; color: #8a9bb5;
  border: 1px solid #1e2a3a; border-radius: 6px; cursor: pointer;
  font-size: 13px; font-family: var(--mono); transition: background 0.15s;
}
.btn-sec:hover { background: #1a2232; }
.btn-sec:disabled { opacity: 0.5; cursor: default; }

.text-input {
  padding: 10px 14px; background: var(--bg-secondary); border: 1px solid var(--border);
  border-radius: 6px; color: var(--text-secondary); font-size: 14px;
  font-family: var(--mono); outline: none;
}

.paper-card {
  background: var(--bg-secondary); border: 1px solid var(--border);
  border-radius: 8px; padding: 18px 20px; margin-bottom: 12px;
  cursor: pointer; transition: border-color 0.15s;
}
.paper-card:hover { border-color: var(--border-hover); }

.section-box {
  background: var(--bg-secondary); border: 1px solid var(--border);
  border-radius: 8px; padding: 14px 18px; margin-bottom: 0;
}
.section-label {
  font-size: 11px; font-family: var(--mono); margin-bottom: 8px;
  text-transform: uppercase; letter-spacing: 1px; color: var(--text-muted);
}

.stat {
  display: inline-flex; align-items: center; gap: 6px;
  padding: 6px 12px; background: var(--bg-secondary);
  border-radius: 6px; font-size: 13px; font-family: var(--mono);
  color: var(--text-muted);
}

.tag { transition: opacity 0.15s; }

ENDFILE_src_index_css

echo 'Creating src/supabase.js...'
cat > src/supabase.js << 'ENDFILE_src_supabase_js'
import { createClient } from '@supabase/supabase-js'

const SUPABASE_URL = 'https://tjdopwduztdzqvzispmp.supabase.co'
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRqZG9wd2R1enRkenF2emlzcG1wIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzODYzMzAsImV4cCI6MjA4OTk2MjMzMH0.EoDPDW5EShkXIPOUnc_IRztvR8aR92yM6wUk1S0vDGE'

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)

export async function getToken() {
  const { data } = await supabase.auth.getSession()
  return data?.session?.access_token || null
}

export async function getUser() {
  const { data } = await supabase.auth.getUser()
  return data?.user || null
}

export async function signUp(email, password) {
  const { data, error } = await supabase.auth.signUp({ email, password })
  if (error) throw error
  return data
}

export async function signIn(email, password) {
  const { data, error } = await supabase.auth.signInWithPassword({ email, password })
  if (error) throw error
  return data
}

export async function signOut() {
  try { await supabase.auth.signOut({ scope: 'local' }) } catch {}
  try {
    Object.keys(localStorage).forEach(k => {
      if (k.includes('supabase') || k.includes('sb-') || k.includes('auth-token')) localStorage.removeItem(k)
    })
  } catch {}
}

export async function getUsage() {
  const { data, error } = await supabase.from('usage').select('*').single()
  if (error) return null
  return data
}

export const FREE_LIMITS = { summaries: 5, gaps: 2, schematics: 3, weekly: 2 }

ENDFILE_src_supabase_js

echo 'Creating src/utils.js...'
cat > src/utils.js << 'ENDFILE_src_utils_js'
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

ENDFILE_src_utils_js

echo 'Creating src/App.jsx...'
cat > src/App.jsx << 'ENDFILE_src_App_jsx'
import { useState, useEffect, useRef, useMemo } from 'react'
import { PK, AK, ZUK, ZKK, GK, gid, ld, sv, genSummary, genGap, genWeeklyRecs, extractPdf, parseBib, parseCsv } from './utils'
import { supabase, getUser, getUsage } from './supabase'
import Settings from './components/Settings'
import DetailView from './components/DetailView'
import GraphView from './components/GraphView'
import GapView from './components/GapView'
import LibraryView from './components/LibraryView'
import AuthModal from './components/AuthModal'

export default function App() {
  const [papers, setPapers] = useState(() => ld(PK, []))
  const [apiKey] = useState('') // Always proxy mode for deployed version
  const [zUid, setZUid] = useState(() => localStorage.getItem(ZUK) || '')
  const [zKey, setZKey] = useState(() => localStorage.getItem(ZKK) || '')
  const [input, setInput] = useState('')
  const [loading, setLoading] = useState(false)
  const [loadingMsg, setLoadingMsg] = useState('')
  const [selected, setSelected] = useState(null)
  const [search, setSearch] = useState('')
  const [filterTags, setFilterTags] = useState([])
  const [readFilter, setReadFilter] = useState('all')
  const [tab, setTab] = useState('library')
  const [error, setError] = useState(null)
  const [pdf, setPdf] = useState(null)
  const fRef = useRef(null), bRef = useRef(null)
  const [speaking, setSpeaking] = useState(false)
  const [gap, setGap] = useState(() => ld(GK, null))
  const [gapL, setGapL] = useState(false)
  const [sumL, setSumL] = useState(false)
  const [impMsg, setImpMsg] = useState('')
  const [showSet, setShowSet] = useState(false)
  const [zotL, setZotL] = useState(false)
  const [zotMsg, setZotMsg] = useState('')
  const [weeklyRecs, setWeeklyRecs] = useState(() => ld('rh_weekly', null))
  const [weeklyL, setWeeklyL] = useState(false)

  // Auth state
  const [user, setUser] = useState(null)
  const [usage, setUsage] = useState(null)
  const [showAuth, setShowAuth] = useState(false)

  // Clean up old API key from localStorage
  useEffect(() => { try { localStorage.removeItem(AK) } catch {} }, [])

  // Check auth on load
  useEffect(() => {
    async function checkAuth() {
      try { const u = await getUser(); setUser(u); if (u) { const us = await getUsage(); setUsage(us) } } catch {}
    }
    checkAuth()
    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, session) => {
      const u = session?.user || null; setUser(u)
      if (u) { try { const us = await getUsage(); setUsage(us) } catch {} } else setUsage(null)
    })
    return () => subscription.unsubscribe()
  }, [])

  async function refreshUsage() { try { const us = await getUsage(); setUsage(us) } catch {} }

  // Debounced save
  const saveTimer = useRef(null)
  useEffect(() => {
    if (saveTimer.current) clearTimeout(saveTimer.current)
    saveTimer.current = setTimeout(() => { try { sv(PK, papers) } catch (e) { console.warn('Storage save failed:', e) } }, 500)
    return () => { if (saveTimer.current) clearTimeout(saveTimer.current) }
  }, [papers])
  useEffect(() => { if (gap) sv(GK, gap) }, [gap])

  // Helper: fetch with 15s timeout
  async function fetchWithTimeout(url, options) {
    const controller = new AbortController()
    const timer = setTimeout(() => controller.abort(), 15000)
    try {
      const r = await fetch(url, { ...options, signal: controller.signal })
      clearTimeout(timer)
      return r
    } catch (e) {
      clearTimeout(timer)
      if (e.name === 'AbortError') throw new Error('Request timed out. Try pasting the paper title instead.')
      throw e
    }
  }

  // ── Add Paper ──────────────────────────────────────────────────────────
  async function addPaper() {
    if (!input.trim() && !pdf) return
    setLoading(true); setError(null)
    try {
      let md = {}
      if (pdf) {
        if (!user) { setError('Please sign in to upload PDFs.'); setShowAuth(true); setLoading(false); return }
        setLoadingMsg('Reading PDF...')
        const b64 = await new Promise((res, rej) => { const r = new FileReader(); r.onload = () => res(r.result.split(',')[1]); r.onerror = () => rej(new Error('Fail')); r.readAsDataURL(pdf) })
        setLoadingMsg('Extracting...')
        md = await extractPdf(apiKey, b64)
        md.source = 'PDF'; md.sourceId = pdf.name
      } else {
        const t = input.trim()
        // IMPORTANT: Check DOI first — DOIs can contain arXiv-like number patterns
        const dm = t.match(/(10\.\d{4,}\/[^\s]+)/)
        // Only match arXiv if no DOI found, and input looks like a standalone arXiv ID
        const am = !dm && t.match(/(?:arxiv\.org\/abs\/)?(\d{4}\.\d{4,5})(?:v\d+)?$/i)

        if (dm) {
          setLoadingMsg('Looking up DOI...')
          const r = await fetch('/api/lookup', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ type: 'doi', query: dm[1] }) })
          if (!r.ok) { const e = await r.json().catch(() => ({})); throw new Error(e.error || 'DOI not found. Try pasting the paper title instead.') }
          const di = await r.json()
          md = { title: di.title, abstract: di.abstract, authors: di.authors, published: di.published, venue: di.venue, source: 'DOI', sourceId: dm[1] }
        } else if (am) {
          setLoadingMsg('Looking up arXiv...')
          const r = await fetch('/api/lookup', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ type: 'arxiv', query: am[1] }) })
          if (!r.ok) { const e = await r.json().catch(() => ({})); throw new Error(e.error || 'arXiv lookup failed') }
          const data = await r.json()
          const x = new DOMParser().parseFromString(data.xml, 'text/xml')
          const e = x.querySelector('entry')
          if (!e || !e.querySelector('title')) throw new Error('Paper not found on arXiv')
          md = { title: e.querySelector('title')?.textContent?.replace(/\s+/g, ' ').trim() || '', abstract: e.querySelector('summary')?.textContent?.trim() || '', authors: [...e.querySelectorAll('author name')].map(n => n.textContent), published: e.querySelector('published')?.textContent?.slice(0, 10) || '', source: 'arXiv', sourceId: am[1] }
        } else {
          setLoadingMsg('Searching...')
          const r = await fetch('/api/lookup', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ type: 'search', query: t }) })
          if (!r.ok) { const e = await r.json().catch(() => ({})); throw new Error(e.error || 'Search failed') }
          const p = await r.json()
          md = { title: p.title, abstract: p.abstract, authors: p.authors, published: p.published, venue: p.venue, source: 'Search', sourceId: p.sourceId }
        }
      }
      if (papers.some(p => p.title?.toLowerCase() === md.title?.toLowerCase())) { setError('Already in library.'); setLoading(false); return }
      // Auto-summarize only if signed in
      let sum = null
      if (user) { try { sum = await genSummary(apiKey, md) } catch (e) { console.warn('Auto-summary:', e.message) } }
      const np = { id: gid(), ...md, summary: sum, addedAt: new Date().toISOString(), notes: '', readStatus: 'unread', figure: null, schematic: null }
      setPapers(prev => [np, ...prev]); setInput(''); setPdf(null); if (fRef.current) fRef.current.value = ''
      setSelected(np); setTab('detail')
      if (sum) refreshUsage()
    } catch (err) { setError(err.message) }
    finally { setLoading(false); setLoadingMsg('') }
  }

  async function bibImp(file) {
    if (!file) return; setLoading(true); setError(null); setImpMsg('Reading...')
    try {
      const text = await file.text(); const isBib = file.name.endsWith('.bib') || text.trim().startsWith('@')
      const entries = isBib ? parseBib(text) : parseCsv(text)
      if (!entries.length) { setError('No papers found.'); setLoading(false); return }
      const ex = new Set(papers.map(p => p.title?.toLowerCase()))
      const nw = entries.filter(e => e.title && !ex.has(e.title.toLowerCase()))
      if (!nw.length) { setError('All duplicates.'); setLoading(false); return }
      setPapers(prev => [...nw.map(e => ({ id: gid(), ...e, summary: null, addedAt: new Date().toISOString(), notes: '', readStatus: 'unread', figure: null, schematic: null })), ...prev])
      setImpMsg('Imported ' + nw.length + ' papers!'); setTimeout(() => setImpMsg(''), 6000)
    } catch (err) { setError('Import failed: ' + err.message) }
    finally { setLoading(false); if (bRef.current) bRef.current.value = '' }
  }

  async function zotImp() {
    if (!zUid || !zKey) { setError('Add Zotero credentials in Settings'); return }
    setZotL(true); setZotMsg('Connecting to Zotero...'); setError(null)
    try {
      let start = 0, all = []
      while (true) {
        const r = await fetch('https://api.zotero.org/users/' + zUid + '/items?format=json&limit=50&start=' + start + '&sort=dateModified&direction=desc', { headers: { 'Zotero-API-Key': zKey, 'Zotero-API-Version': '3' } })
        if (!r.ok) {
          if (r.status === 403) throw new Error('Zotero 403 - check your API key has read access')
          if (r.status === 404) throw new Error('Zotero 404 - check your User ID')
          throw new Error('Zotero error ' + r.status)
        }
        const items = await r.json(); if (!items.length) break
        all = [...all, ...items]; setZotMsg('Found ' + all.length + ' items...')
        if (items.length < 50 || all.length > 500) break; start += 50
      }
      const types = new Set(['journalArticle', 'conferencePaper', 'preprint', 'book', 'bookSection', 'thesis', 'report', 'manuscript', 'document'])
      const zi = all.filter(i => types.has(i.data?.itemType))
      setZotMsg('Found ' + zi.length + ' papers. Checking duplicates...')
      const ex = new Set(papers.map(p => p.title?.toLowerCase().trim())); const nw = []; let skipped = 0
      for (const item of zi) {
        const d = item.data; if (!d.title) continue
        if (ex.has(d.title.toLowerCase().trim())) { skipped++; continue }
        ex.add(d.title.toLowerCase().trim())
        nw.push({ id: gid(), title: d.title, authors: (d.creators || []).filter(c => c.creatorType === 'author').map(c => ((c.firstName || '') + ' ' + (c.lastName || '')).trim()), abstract: d.abstractNote || '', published: d.date || '', venue: d.publicationTitle || d.proceedingsTitle || d.bookTitle || '', source: 'Zotero', sourceId: d.DOI || d.key, url: d.url || '', summary: null, addedAt: new Date().toISOString(), notes: '', readStatus: 'unread', figure: null, schematic: null, starred: false })
      }
      if (nw.length) setPapers(prev => [...nw, ...prev])
      setZotMsg('Imported ' + nw.length + ' new papers' + (skipped > 0 ? ' (' + skipped + ' duplicates skipped)' : ''))
      setTimeout(() => setZotMsg(''), 10000)
    } catch (err) { setError('Zotero failed: ' + err.message) }
    finally { setZotL(false) }
  }

  async function sumAll() {
    const un = papers.filter(p => !p.summary); if (!un.length) return
    if (!user) { setError('Please sign in to use AI summaries.'); setShowAuth(true); return }
    setSumL(true); setError(null); let upd = [...papers]
    for (let i = 0; i < un.length; i++) {
      setLoadingMsg('Summarizing ' + (i + 1) + '/' + un.length + ': ' + un[i].title.slice(0, 35) + '...')
      try {
        const s = await genSummary(apiKey, un[i])
        upd = upd.map(p => p.id === un[i].id ? { ...p, summary: s } : p)
      } catch (e) {
        if (e.message?.includes('limit reached')) { setError(e.message); break }
        upd = upd.map(p => p.id === un[i].id ? { ...p, summary: { tldr: (p.abstract || '').slice(0, 100), tags: ['untagged'], key_contributions: [], methods: [], limitations: [], open_questions: [], key_citations_to_follow: [], relevance_to_medical_imaging: '' } } : p)
      }
    }
    setPapers(upd); setSumL(false); setLoadingMsg(''); refreshUsage()
  }

  async function runGap() {
    if (papers.length < 2) { setError('Need 2+ papers'); return }
    if (!user) { setError('Please sign in to use gap analysis.'); setShowAuth(true); return }
    setGapL(true); setError(null)
    try {
      const parsed = await genGap(apiKey, papers)
      setGap(parsed); setTab('gaps'); refreshUsage()
    } catch (err) { setError('Gap analysis failed: ' + (err.message || 'Unknown error')) }
    finally { setGapL(false) }
  }

  async function genWeekly() {
    if (papers.length < 3) { setError('Need 3+ papers for reading suggestions.'); return }
    if (!user) { setError('Please sign in for weekly reading suggestions.'); setShowAuth(true); return }
    setWeeklyL(true); setError(null)
    try {
      const parsed = await genWeeklyRecs(apiKey, papers)
      parsed.generatedAt = new Date().toISOString()
      setWeeklyRecs(parsed); sv('rh_weekly', parsed); refreshUsage()
    } catch (err) { setError('Weekly suggestions failed: ' + err.message) }
    finally { setWeeklyL(false) }
  }

  function del(id) { setPapers(p => p.filter(x => x.id !== id)); if (selected?.id === id) { setSelected(null); setTab('library') } }
  function togRead(id) { setPapers(p => p.map(x => x.id === id ? { ...x, readStatus: x.readStatus === 'read' ? 'unread' : 'read' } : x)) }
  function togStar(id) { setPapers(p => p.map(x => x.id === id ? { ...x, starred: !x.starred } : x)); if (selected?.id === id) setSelected(p => ({ ...p, starred: !p.starred })) }
  function updNotes(id, n) { setPapers(p => p.map(x => x.id === id ? { ...x, notes: n } : x)); if (selected?.id === id) setSelected(p => ({ ...p, notes: n })) }
  function updFigure(id, fig) {
    if (fig && fig.length > 2000000) { if (!confirm('This image is large. Continue?')) return }
    setPapers(p => p.map(x => x.id === id ? { ...x, figure: fig } : x))
    if (selected?.id === id) setSelected(p => ({ ...p, figure: fig }))
  }
  function updSchematic(id, svg) { setPapers(p => p.map(x => x.id === id ? { ...x, schematic: svg } : x)); if (selected?.id === id) setSelected(p => ({ ...p, schematic: svg })) }
  function spk(p) { if (speaking) { speechSynthesis.cancel(); setSpeaking(false); return }; const u = new SpeechSynthesisUtterance(p.title + '. ' + (p.summary?.tldr || '')); u.rate = 0.95; u.onend = () => setSpeaking(false); setSpeaking(true); speechSynthesis.speak(u) }

  const [showStarred, setShowStarred] = useState(false)

  const allTags = useMemo(() => [...new Set(papers.flatMap(p => p.summary?.tags || []))], [papers])
  const filtered = useMemo(() => papers.filter(p => {
    const ms = !search || p.title?.toLowerCase().includes(search.toLowerCase()) || p.summary?.tldr?.toLowerCase().includes(search.toLowerCase()) || p.authors?.some(a => a.toLowerCase().includes(search.toLowerCase()))
    const tagMatch = filterTags.length === 0 || filterTags.some(t => p.summary?.tags?.includes(t))
    const starMatch = !showStarred || p.starred
    const readMatch = readFilter === 'all' || (readFilter === 'read' && p.readStatus === 'read') || (readFilter === 'unread' && p.readStatus !== 'read')
    return ms && tagMatch && starMatch && readMatch
  }), [papers, search, filterTags, showStarred, readFilter])
  const unsum = useMemo(() => papers.filter(p => !p.summary).length, [papers])

  // ── Header ─────────────────────────────────────────────────────────────
  const headerEl = (
    <>
      <header style={{ padding: '24px 32px 16px', borderBottom: '1px solid var(--border)', background: 'linear-gradient(180deg, var(--bg-tertiary) 0%, var(--bg-primary) 100%)', display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <div>
          <h1 style={{ fontSize: 26, fontWeight: 400, color: 'var(--text-primary)', letterSpacing: -0.5, margin: 0 }}>Research<span style={{ color: 'var(--accent-green)', fontStyle: 'italic' }}>Hub</span></h1>
          <div style={{ fontSize: 13, color: 'var(--text-muted)', fontFamily: 'var(--mono)', marginTop: 4 }}>{papers.length} papers</div>
        </div>
        <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
          <button onClick={() => setShowAuth(true)} className="btn-sec" style={{ padding: '8px 14px', fontSize: 12, fontFamily: 'var(--mono)', color: user ? 'var(--accent-green-light)' : 'var(--text-muted)' }}>
            {user ? (user.email.split('@')[0]) : 'Sign In'}
          </button>
          <button onClick={() => setShowSet(true)} className="btn-sec" style={{ padding: '8px 14px', fontSize: 16 }}>⚙</button>
        </div>
      </header>
      {!user && <div style={{ padding: '10px 32px', background: '#1a1520', borderBottom: '1px solid #2a2535', fontSize: 13, color: 'var(--accent-purple)', fontFamily: 'var(--mono)', cursor: 'pointer' }} onClick={() => setShowAuth(true)}>Sign in for AI summaries, gap analysis, and more — free account, no credit card</div>}
      {(zotL || zotMsg) && <div style={{ padding: '10px 32px', background: '#0f1520', borderBottom: '1px solid #1a2a3a', fontSize: 13, color: 'var(--accent-blue)', fontFamily: 'var(--mono)' }}>{zotL ? '⟳ ' : '✓ '}{zotMsg}</div>}
      <div style={{ display: 'flex', gap: 0, borderBottom: '1px solid var(--border)' }}>
        {['library', 'graph', 'gaps'].map(t => <button key={t} onClick={() => setTab(t)} style={{ padding: '10px 24px', fontSize: 13, fontFamily: 'var(--mono)', color: (tab === t || (tab === 'detail' && t === 'library')) ? 'var(--accent-green-light)' : 'var(--text-faint)', background: (tab === t || (tab === 'detail' && t === 'library')) ? '#0f1a15' : 'transparent', cursor: 'pointer', border: 'none', borderBottom: (tab === t || (tab === 'detail' && t === 'library')) ? '2px solid var(--accent-green)' : '2px solid transparent', textTransform: 'capitalize' }}>{t === 'gaps' ? 'Gap Analysis' : t === 'graph' ? 'Relationships' : t}</button>)}
      </div>
      <div style={{ padding: '16px 32px', borderBottom: '1px solid var(--border)', display: 'flex', gap: 10, alignItems: 'center', flexWrap: 'wrap' }}>
        <input value={input} onChange={e => setInput(e.target.value)} onKeyDown={e => { if (e.key === 'Enter' && !loading) addPaper() }} placeholder="Paste arXiv URL, DOI, or paper title..." className="text-input" style={{ flex: 1, minWidth: 200 }} disabled={loading} />
        <input ref={fRef} type="file" accept=".pdf" onChange={e => setPdf(e.target.files?.[0] || null)} style={{ display: 'none' }} />
        <input ref={bRef} type="file" accept=".bib,.csv,.tsv,.txt" onChange={e => { if (e.target.files?.[0]) bibImp(e.target.files[0]) }} style={{ display: 'none' }} />
        <button onClick={() => fRef.current?.click()} className="btn-sec" disabled={loading}>{pdf ? '📄 ' + pdf.name.slice(0, 12) + '…' : 'PDF'}</button>
        <button onClick={() => bRef.current?.click()} className="btn-sec" style={{ color: 'var(--accent-blue)', borderColor: '#1e2a4a' }} disabled={loading}>BibTeX/CSV</button>
        <button onClick={addPaper} disabled={loading || (!input.trim() && !pdf)} className="btn-primary" style={{ opacity: loading || (!input.trim() && !pdf) ? 0.5 : 1 }}>{loading ? loadingMsg || '...' : '+ Add'}</button>
      </div>
      {impMsg && <div style={{ padding: '10px 32px', background: '#0f1a15', borderBottom: '1px solid #1a3329', fontSize: 13, color: 'var(--accent-green-light)', fontFamily: 'var(--mono)' }}>✓ {impMsg}</div>}
      {error && <div style={{ margin: '12px 32px 0', padding: '10px 14px', background: '#2a1515', border: '1px solid #4a2020', borderRadius: 6, fontSize: 13, color: '#d49090', fontFamily: 'var(--mono)', display: 'flex', justifyContent: 'space-between' }}>{error}<span onClick={() => setError(null)} style={{ cursor: 'pointer', color: '#8a5050' }}>✕</span></div>}
    </>
  )

  const settingsEl = <Settings show={showSet} onClose={() => setShowSet(false)} zUid={zUid} setZUid={setZUid} zKey={zKey} setZKey={setZKey} zotImp={zotImp} zotL={zotL} papers={papers} setPapers={setPapers} gap={gap} setGap={setGap} />
  const authEl = <AuthModal show={showAuth} onClose={() => setShowAuth(false)} user={user} usage={usage} onAuthChange={async () => { const u = await getUser(); setUser(u); if (u) { const us = await getUsage(); setUsage(us) } else setUsage(null) }} />

  if (tab === 'detail' && selected) {
    return (<div>{headerEl}<DetailView paper={selected} apiKey={apiKey} onBack={() => { speechSynthesis.cancel(); setSpeaking(false); setTab('library') }} onDelete={del} onToggleRead={togRead} onToggleStar={togStar} onUpdateNotes={updNotes} onUpdateFigure={updFigure} onUpdateSchematic={updSchematic} speaking={speaking} onSpeak={spk} />{settingsEl}{authEl}</div>)
  }
  if (tab === 'graph') {
    return (<div>{headerEl}<GraphView papers={papers} onSelect={id => { const p = papers.find(x => x.id === id); if (p) { setSelected(p); setTab('detail') } }} />{settingsEl}{authEl}</div>)
  }
  if (tab === 'gaps') {
    return (<div>{headerEl}<GapView papers={papers} gap={gap} gapL={gapL} onRunGap={runGap} />{settingsEl}{authEl}</div>)
  }

  return (<div>{headerEl}<LibraryView papers={papers} filtered={filtered} allTags={allTags} filterTags={filterTags} setFilterTags={setFilterTags} readFilter={readFilter} setReadFilter={setReadFilter} search={search} setSearch={setSearch} unsum={unsum} sumL={sumL} loadingMsg={loadingMsg} onSumAll={sumAll} onSelect={p => { setSelected(p); setTab('detail') }} onToggleStar={togStar} showStarred={showStarred} setShowStarred={setShowStarred} weeklyRecs={weeklyRecs} weeklyL={weeklyL} onGenWeekly={genWeekly} />{settingsEl}{authEl}</div>)
}

ENDFILE_src_App_jsx

echo 'Creating src/components/AuthModal.jsx...'
cat > src/components/AuthModal.jsx << 'ENDFILE_src_components_AuthModal_jsx'
import { useState } from 'react'
import { signUp, signIn, signOut, FREE_LIMITS } from '../supabase'

export default function AuthModal({ show, onClose, user, usage, onAuthChange }) {
  const [mode, setMode] = useState('login')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [msg, setMsg] = useState('')

  if (!show) return null

  const isty = { width: '100%', padding: '10px 14px', background: 'var(--bg-primary)', border: '1px solid var(--border)', borderRadius: 6, color: 'var(--text-secondary)', fontSize: 14, fontFamily: 'var(--mono)', outline: 'none', boxSizing: 'border-box', marginBottom: 12 }

  async function handleSubmit(e) {
    e.preventDefault()
    setLoading(true); setError(''); setMsg('')
    try {
      if (mode === 'signup') {
        await signUp(email, password)
        setMsg('Account created!')
        await signIn(email, password)
      } else {
        await signIn(email, password)
      }
      onAuthChange()
      setTimeout(() => onClose(), 500)
    } catch (err) { setError(err.message || 'Authentication failed') }
    finally { setLoading(false) }
  }

  function handleSignOut() {
    // Clear auth storage synchronously — don't await anything
    try { Object.keys(localStorage).forEach(k => { if (k.includes('supabase') || k.includes('sb-') || k.includes('auth')) localStorage.removeItem(k) }) } catch {}
    // Reload immediately
    window.location.reload()
  }

  if (user) {
    const isPro = usage?.tier === 'pro'
    return (
      <div style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.7)', zIndex: 100, display: 'flex', alignItems: 'center', justifyContent: 'center' }} onClick={e => { if (e.target === e.currentTarget) onClose() }}>
        <div style={{ background: 'var(--bg-secondary)', border: '1px solid var(--border)', borderRadius: 12, padding: 32, width: 420, maxWidth: '90vw' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 24 }}>
            <h3 style={{ fontSize: 18, color: 'var(--text-primary)', fontWeight: 400, margin: 0 }}>Account</h3>
            <span onClick={onClose} style={{ cursor: 'pointer', color: 'var(--text-muted)', fontSize: 18 }}>✕</span>
          </div>
          <div style={{ fontSize: 13, color: 'var(--text-secondary)', fontFamily: 'var(--mono)', marginBottom: 16 }}>{user.email}</div>
          <div style={{ display: 'inline-block', padding: '4px 12px', borderRadius: 4, fontSize: 12, fontFamily: 'var(--mono)', background: isPro ? '#1a2e1a' : '#1a1a2e', color: isPro ? 'var(--accent-green-light)' : 'var(--accent-blue)', border: '1px solid ' + (isPro ? '#2a4a2a' : '#2a2a4a'), marginBottom: 20 }}>
            {isPro ? '★ PRO' : 'FREE TIER'}
          </div>
          {usage && (
            <div style={{ background: 'var(--bg-primary)', border: '1px solid var(--border)', borderRadius: 8, padding: 16, marginBottom: 20 }}>
              <div style={{ fontSize: 12, color: 'var(--text-muted)', fontFamily: 'var(--mono)', marginBottom: 10, textTransform: 'uppercase' }}>Usage</div>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
                {[
                  { label: 'Summaries', used: usage.summary_count || 0, limit: isPro ? '∞' : FREE_LIMITS.summaries },
                  { label: 'Gap Analyses', used: usage.gap_count || 0, limit: isPro ? '∞' : FREE_LIMITS.gaps },
                  { label: 'Schematics', used: usage.schematic_count || 0, limit: isPro ? '∞' : FREE_LIMITS.schematics },
                ].map(s => (
                  <div key={s.label} style={{ fontSize: 12, fontFamily: 'var(--mono)' }}>
                    <span style={{ color: 'var(--text-faint)' }}>{s.label}: </span>
                    <span style={{ color: typeof s.limit === 'number' && s.used >= s.limit ? 'var(--accent-red)' : 'var(--text-secondary)' }}>{s.used}/{s.limit}</span>
                  </div>
                ))}
              </div>
            </div>
          )}
          {!isPro && (
            <a href="https://buy.stripe.com/bJe7sE4CBbiAcR50zS7AI00" target="_blank" rel="noopener" style={{ display: 'block', textAlign: 'center', padding: '12px 20px', background: 'var(--accent-green)', color: '#fff', borderRadius: 8, textDecoration: 'none', fontSize: 14, fontWeight: 500, marginBottom: 16, fontFamily: 'var(--sans)' }}>
              Upgrade to Pro — $8/month
            </a>
          )}
          <button onClick={(e) => { e.stopPropagation(); handleSignOut() }} style={{ width: '100%', textAlign: 'center', color: '#d19090', background: 'transparent', border: '1px solid #3a1a1a', borderRadius: 6, padding: '10px 16px', fontSize: 14, cursor: 'pointer', fontFamily: 'var(--sans)' }}>Sign Out</button>
        </div>
      </div>
    )
  }

  return (
    <div style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.7)', zIndex: 100, display: 'flex', alignItems: 'center', justifyContent: 'center' }} onClick={e => { if (e.target === e.currentTarget) onClose() }}>
      <div style={{ background: 'var(--bg-secondary)', border: '1px solid var(--border)', borderRadius: 12, padding: 32, width: 420, maxWidth: '90vw' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 8 }}>
          <h3 style={{ fontSize: 22, color: 'var(--text-primary)', fontWeight: 400, margin: 0, fontFamily: 'var(--sans)' }}>Research<span style={{ color: 'var(--accent-green)', fontStyle: 'italic' }}>Hub</span></h3>
          <span onClick={onClose} style={{ cursor: 'pointer', color: 'var(--text-muted)', fontSize: 18 }}>✕</span>
        </div>
        <div style={{ fontSize: 13, color: 'var(--text-faint)', marginBottom: 24 }}>{mode === 'login' ? 'Sign in to your account' : 'Create your free account'}</div>
        {error && <div style={{ padding: '8px 12px', background: '#2a1515', border: '1px solid #4a2020', borderRadius: 6, fontSize: 12, color: '#d49090', fontFamily: 'var(--mono)', marginBottom: 12 }}>{error}</div>}
        {msg && <div style={{ padding: '8px 12px', background: '#0f1a15', border: '1px solid #1a3329', borderRadius: 6, fontSize: 12, color: 'var(--accent-green-light)', fontFamily: 'var(--mono)', marginBottom: 12 }}>{msg}</div>}
        <div>
          <label style={{ fontSize: 12, color: 'var(--text-muted)', fontFamily: 'var(--mono)' }}>Email</label>
          <input value={email} onChange={e => setEmail(e.target.value)} type="email" placeholder="you@university.edu" style={isty} />
          <label style={{ fontSize: 12, color: 'var(--text-muted)', fontFamily: 'var(--mono)' }}>Password</label>
          <input value={password} onChange={e => setPassword(e.target.value)} type="password" placeholder={mode === 'signup' ? 'At least 6 characters' : 'Your password'} style={isty} onKeyDown={e => { if (e.key === 'Enter') handleSubmit(e) }} />
          <button onClick={handleSubmit} disabled={loading || !email || !password} className="btn-primary" style={{ width: '100%', textAlign: 'center', marginBottom: 12, opacity: (!email || !password) ? 0.5 : 1 }}>
            {loading ? 'Please wait...' : mode === 'login' ? 'Sign In' : 'Create Account'}
          </button>
        </div>
        <div style={{ textAlign: 'center', fontSize: 13, color: 'var(--text-faint)' }}>
          {mode === 'login' ? (
            <span>No account? <span onClick={() => { setMode('signup'); setError(''); setMsg('') }} style={{ color: 'var(--accent-green-light)', cursor: 'pointer' }}>Sign up free</span></span>
          ) : (
            <span>Already have an account? <span onClick={() => { setMode('login'); setError(''); setMsg('') }} style={{ color: 'var(--accent-green-light)', cursor: 'pointer' }}>Sign in</span></span>
          )}
        </div>
        {mode === 'signup' && (
          <div style={{ marginTop: 16, fontSize: 11, color: 'var(--text-faint)', fontFamily: 'var(--mono)', textAlign: 'center', lineHeight: 1.5 }}>
            Free: {FREE_LIMITS.summaries} summaries · {FREE_LIMITS.gaps} gap analyses · {FREE_LIMITS.schematics} schematics / Pro: $8/month unlimited
          </div>
        )}
      </div>
    </div>
  )
}

ENDFILE_src_components_AuthModal_jsx

echo 'Creating src/components/Settings.jsx...'
cat > src/components/Settings.jsx << 'ENDFILE_src_components_Settings_jsx'
import { useState, useEffect, useRef } from 'react'
import { sv, ZUK, ZKK } from '../utils'

function download(filename, content, type) {
  const blob = new Blob([content], { type })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url; a.download = filename; a.click()
  URL.revokeObjectURL(url)
}

function toBibtex(papers) {
  return papers.map((p, i) => {
    const key = (p.authors?.[0]?.split(' ').pop() || 'Unknown').toLowerCase() + (p.published?.slice(0, 4) || '') + String.fromCharCode(97 + (i % 26))
    const authors = (p.authors || []).join(' and ')
    const lines = ['@article{' + key + ',']
    lines.push('  title = {' + (p.title || '') + '},')
    if (authors) lines.push('  author = {' + authors + '},')
    if (p.published) lines.push('  year = {' + p.published.slice(0, 4) + '},')
    if (p.venue) lines.push('  journal = {' + p.venue + '},')
    if (p.abstract) lines.push('  abstract = {' + p.abstract.replace(/[{}]/g, '') + '},')
    if (p.sourceId?.match(/^10\./)) lines.push('  doi = {' + p.sourceId + '},')
    if (p.notes) lines.push('  note = {' + p.notes.replace(/[{}]/g, '') + '},')
    lines.push('}')
    return lines.join('\n')
  }).join('\n\n')
}

function toCsv(papers) {
  const esc = (s) => '"' + (s || '').replace(/"/g, '""') + '"'
  const headers = ['Title', 'Authors', 'Year', 'Venue', 'DOI/ID', 'Source', 'TLDR', 'Tags', 'Key Contributions', 'Methods', 'Limitations', 'Open Questions', 'Relevance', 'Notes', 'Read Status', 'Starred', 'Abstract']
  const rows = papers.map(p => {
    const s = p.summary || {}
    return [
      esc(p.title), esc((p.authors || []).join('; ')), esc(p.published?.slice(0, 4)),
      esc(p.venue), esc(p.sourceId), esc(p.source), esc(s.tldr),
      esc((s.tags || []).join('; ')), esc((s.key_contributions || []).join('; ')),
      esc((s.methods || []).join('; ')), esc((s.limitations || []).join('; ')),
      esc((s.open_questions || []).join('; ')), esc(s.relevance_to_medical_imaging),
      esc(p.notes), esc(p.readStatus), esc(p.starred ? 'Yes' : 'No'), esc(p.abstract),
    ].join(',')
  })
  return headers.join(',') + '\n' + rows.join('\n')
}

export default function Settings({ show, onClose, zUid, setZUid, zKey, setZKey, zotImp, zotL, papers, setPapers, gap, setGap }) {
  const [tZU, setTZU] = useState(zUid)
  const [tZK, setTZK] = useState(zKey)
  const [msg, setMsg] = useState('')
  const restoreRef = useRef(null)

  useEffect(() => {
    if (show) { setTZU(zUid); setTZK(zKey); setMsg('') }
  }, [show, zUid, zKey])

  if (!show) return null

  const isty = { width: '100%', padding: '10px 14px', background: 'var(--bg-primary)', border: '1px solid var(--border)', borderRadius: 6, color: 'var(--text-secondary)', fontSize: 14, fontFamily: 'var(--mono)', outline: 'none', boxSizing: 'border-box', marginBottom: 12 }
  const secHead = (label, color) => ({ fontSize: 13, color, fontFamily: 'var(--mono)', marginBottom: 8, textTransform: 'uppercase', letterSpacing: 1 })

  function exportBackup() {
    const data = { version: 1, exportedAt: new Date().toISOString(), papers: papers, gap: gap }
    const date = new Date().toISOString().slice(0, 10)
    download('researchhub-backup-' + date + '.json', JSON.stringify(data, null, 2), 'application/json')
    setMsg('Backup exported! (' + papers.length + ' papers)')
    setTimeout(() => setMsg(''), 5000)
  }

  function importBackup(file) {
    if (!file) return
    const reader = new FileReader()
    reader.onload = (e) => {
      try {
        const data = JSON.parse(e.target.result)
        if (!data.papers || !Array.isArray(data.papers)) throw new Error('Invalid backup file')
        const count = data.papers.length
        if (!confirm('This will replace your current library (' + papers.length + ' papers) with the backup (' + count + ' papers). Continue?')) return
        setPapers(data.papers)
        if (data.gap) setGap(data.gap)
        setMsg('Restored ' + count + ' papers from backup!')
        setTimeout(() => setMsg(''), 5000)
      } catch (err) { setMsg('Import failed: ' + err.message) }
    }
    reader.readAsText(file)
    if (restoreRef.current) restoreRef.current.value = ''
  }

  function exportBibtex() {
    const bib = toBibtex(papers)
    const date = new Date().toISOString().slice(0, 10)
    download('researchhub-' + date + '.bib', bib, 'text/plain')
    setMsg('BibTeX exported! (' + papers.length + ' entries)')
    setTimeout(() => setMsg(''), 5000)
  }

  function exportCsv() {
    const csv = toCsv(papers)
    const date = new Date().toISOString().slice(0, 10)
    download('researchhub-' + date + '.csv', csv, 'text/csv')
    setMsg('CSV exported with summaries and notes!')
    setTimeout(() => setMsg(''), 5000)
  }

  return (
    <div style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.7)', zIndex: 100, display: 'flex', alignItems: 'center', justifyContent: 'center' }} onClick={e => { if (e.target === e.currentTarget) onClose() }}>
      <div style={{ background: 'var(--bg-secondary)', border: '1px solid var(--border)', borderRadius: 12, padding: 32, width: 520, maxWidth: '90vw', maxHeight: '90vh', overflowY: 'auto' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 24 }}>
          <h3 style={{ fontSize: 18, color: 'var(--text-primary)', fontWeight: 400, margin: 0 }}>Settings</h3>
          <span onClick={onClose} style={{ cursor: 'pointer', color: 'var(--text-muted)', fontSize: 18 }}>✕</span>
        </div>

        {msg && <div style={{ padding: '8px 12px', background: '#0f1a15', border: '1px solid #1a3329', borderRadius: 6, fontSize: 12, color: 'var(--accent-green-light)', fontFamily: 'var(--mono)', marginBottom: 16 }}>{msg}</div>}

        {/* Zotero */}
        <div style={{ marginBottom: 24 }}>
          <div style={secHead('Zotero', 'var(--accent-blue)')}>Zotero</div>
          <div style={{ fontSize: 12, color: 'var(--text-faint)', marginBottom: 8, lineHeight: 1.5 }}>Get API key at <a href="https://www.zotero.org/settings/keys" target="_blank" rel="noopener" style={{ color: 'var(--accent-blue)' }}>zotero.org/settings/keys</a></div>
          <label style={{ fontSize: 12, color: 'var(--text-muted)', fontFamily: 'var(--mono)' }}>User ID</label>
          <input value={tZU} onChange={e => setTZU(e.target.value)} placeholder="e.g. 8968548" style={isty} />
          <label style={{ fontSize: 12, color: 'var(--text-muted)', fontFamily: 'var(--mono)' }}>API Key</label>
          <input value={tZK} onChange={e => setTZK(e.target.value)} placeholder="Zotero API key" type="password" style={isty} />
          <div style={{ display: 'flex', gap: 8 }}>
            <button onClick={() => { setZUid(tZU); setZKey(tZK); sv(ZUK, tZU); sv(ZKK, tZK) }} className="btn-sec" style={{ flex: 1, textAlign: 'center' }}>Save</button>
            <button onClick={() => { setZUid(tZU); setZKey(tZK); sv(ZUK, tZU); sv(ZKK, tZK); onClose(); zotImp() }} disabled={!tZU || !tZK || zotL} className="btn-primary" style={{ flex: 1, textAlign: 'center', background: '#1a2a33', color: 'var(--accent-blue)', borderColor: '#2a4a5a', opacity: (!tZU || !tZK) ? 0.4 : 1 }}>{zotL ? 'Importing...' : 'Import Zotero'}</button>
          </div>
        </div>

        {/* Backup & Restore */}
        <div style={{ marginBottom: 24, borderTop: '1px solid var(--border)', paddingTop: 20 }}>
          <div style={secHead('Backup & Restore', 'var(--accent-purple)')}>Backup & Restore</div>
          <div style={{ fontSize: 12, color: 'var(--text-faint)', marginBottom: 12, lineHeight: 1.5 }}>Save a full backup of your library including summaries, notes, figures, schematics, and gap analysis.</div>
          <div style={{ display: 'flex', gap: 8, marginBottom: 8 }}>
            <button onClick={exportBackup} className="btn-primary" style={{ flex: 1, textAlign: 'center', background: '#1a1a2e', color: 'var(--accent-purple)', borderColor: '#2a2a4a' }}>📦 Export Full Backup</button>
            <button onClick={() => restoreRef.current?.click()} className="btn-sec" style={{ flex: 1, textAlign: 'center' }}>📂 Restore from Backup</button>
          </div>
          <input ref={restoreRef} type="file" accept=".json" onChange={e => { if (e.target.files?.[0]) importBackup(e.target.files[0]) }} style={{ display: 'none' }} />
          <div style={{ fontSize: 11, color: 'var(--text-faint)', fontFamily: 'var(--mono)' }}>Backup includes: {papers.length} papers, {papers.filter(p => p.summary).length} summaries, {papers.filter(p => p.notes).length} with notes</div>
        </div>

        {/* Export */}
        <div style={{ marginBottom: 24, borderTop: '1px solid var(--border)', paddingTop: 20 }}>
          <div style={secHead('Export Citations & Notes', '#5bc4b0')}>Export Citations & Notes</div>
          <div style={{ display: 'flex', gap: 8 }}>
            <button onClick={exportBibtex} className="btn-sec" style={{ flex: 1, textAlign: 'center' }}>📝 Export BibTeX</button>
            <button onClick={exportCsv} className="btn-sec" style={{ flex: 1, textAlign: 'center' }}>📊 Export CSV</button>
          </div>
        </div>

        {/* Reset */}
        <div style={{ borderTop: '1px solid var(--border)', paddingTop: 16 }}>
          <button onClick={() => { if (confirm('Clear all papers and data? Export a backup first!')) { localStorage.removeItem('rh_papers'); localStorage.removeItem('rh_gap'); window.location.reload() } }} className="btn-sec" style={{ width: '100%', textAlign: 'center', color: 'var(--accent-red)', borderColor: '#3a1a1a' }}>Reset Library</button>
        </div>
      </div>
    </div>
  )
}

ENDFILE_src_components_Settings_jsx

echo 'Creating src/components/DetailView.jsx...'
cat > src/components/DetailView.jsx << 'ENDFILE_src_components_DetailView_jsx'
import { useState, useRef } from 'react'
import { tagStyle, getPaperUrl, getPdfUrl, genSchematic } from '../utils'

export default function DetailView({ paper, apiKey, onBack, onDelete, onToggleRead, onToggleStar, onUpdateNotes, onUpdateFigure, onUpdateSchematic, speaking, onSpeak }) {
  const p = paper, s = p.summary || {}
  const pUrl = getPaperUrl(p), pdfUrl = getPdfUrl(p)
  const figRef = useRef(null)
  const [genL, setGenL] = useState(false)

  async function handleGenSchematic() {
    if (!apiKey) { alert('Add API key in ⚙ Settings first.'); return }
    setGenL(true)
    try {
      const svg = await genSchematic(apiKey, p)
      onUpdateSchematic(p.id, svg)
    } catch (e) { alert('Schematic generation failed: ' + e.message) }
    finally { setGenL(false) }
  }

  function handleFigUpload(e) {
    const file = e.target.files?.[0]
    if (!file) return
    const reader = new FileReader()
    reader.onload = (ev) => { onUpdateFigure(p.id, ev.target.result) }
    reader.readAsDataURL(file)
  }

  return (
    <div style={{ padding: '20px 32px' }}>
      <button onClick={onBack} className="btn-sec" style={{ marginBottom: 20 }}>← Back</button>

      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 16, flexWrap: 'wrap' }}>
        <div style={{ flex: 1 }}>
          <h2 style={{ fontSize: 22, color: 'var(--text-primary)', fontWeight: 400, lineHeight: 1.3, margin: '0 0 8px' }}>{p.title}</h2>
          <div style={{ fontSize: 13, color: 'var(--accent-green)', fontFamily: 'var(--mono)', marginBottom: 6 }}>{(p.authors || []).join(', ')}</div>
          <div style={{ fontSize: 12, color: 'var(--text-faint)', fontFamily: 'var(--mono)', marginBottom: 8 }}>{p.published} · {p.source}{p.venue ? ' · ' + p.venue : ''}</div>
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
            {pUrl && <a href={pUrl} target="_blank" rel="noopener" className="btn-sec" style={{ textDecoration: 'none', padding: '6px 12px', fontSize: 12, color: 'var(--accent-blue)' }}>🔗 View Paper</a>}
            {pdfUrl && <a href={pdfUrl} target="_blank" rel="noopener" className="btn-sec" style={{ textDecoration: 'none', padding: '6px 12px', fontSize: 12, color: 'var(--accent-green-light)' }}>📄 PDF</a>}
          </div>
        </div>
        <div style={{ display: 'flex', gap: 8 }}>
          <button onClick={() => onToggleStar(p.id)} className="btn-sec" style={{ color: p.starred ? '#c4c470' : 'var(--text-muted)', fontSize: 16, padding: '8px 12px' }}>{p.starred ? '★' : '☆'}</button>
          <button onClick={() => onSpeak(p)} className="btn-primary">{speaking ? '■ Stop' : '▶ Listen'}</button>
          <button onClick={() => onToggleRead(p.id)} className="btn-sec">{p.readStatus === 'read' ? '✓ Read' : '○ Unread'}</button>
          <button onClick={() => onDelete(p.id)} className="btn-sec" style={{ color: 'var(--accent-red)' }}>Delete</button>
        </div>
      </div>

      <div style={{ marginTop: 24 }}>
        {/* TLDR */}
        {s.tldr ? (
          <div className="section-box" style={{ background: '#0f1a15', borderColor: '#1a3329', marginBottom: 16 }}>
            <div className="section-label" style={{ color: 'var(--accent-green)' }}>TLDR</div>
            <div style={{ fontSize: 15, color: '#c4d4cc', lineHeight: 1.5 }}>{s.tldr}</div>
          </div>
        ) : <div className="section-box" style={{ background: '#1a1a15', borderColor: '#3a3329', marginBottom: 16, color: 'var(--accent-orange)', fontFamily: 'var(--mono)', fontSize: 13 }}>No summary yet. ⚡ Summarize All in library.</div>}

        {s.tags?.length > 0 && <div style={{ marginBottom: 16 }}>{s.tags.map(t => <span key={t} style={tagStyle(t)}>{t}</span>)}</div>}

        {/* Key Figure / Schematic */}
        <div className="section-box" style={{ marginBottom: 16 }}>
          <div className="section-label" style={{ color: 'var(--accent-blue)' }}>Visual Overview</div>

          {/* AI Schematic */}
          {p.schematic && p.schematic.trim().startsWith('<svg') ? (
            <div style={{ marginBottom: 12 }}>
              <div style={{ fontSize: 11, color: 'var(--text-muted)', fontFamily: 'var(--mono)', marginBottom: 6 }}>AI-Generated Schematic</div>
              <div style={{ background: '#111822', borderRadius: 6, padding: 8, overflow: 'auto' }} dangerouslySetInnerHTML={{ __html: p.schematic }} />
              <button onClick={handleGenSchematic} disabled={genL} className="btn-sec" style={{ marginTop: 8, fontSize: 11, padding: '4px 10px' }}>{genL ? 'Regenerating...' : '↻ Regenerate'}</button>
            </div>
          ) : p.schematic ? (
            <div style={{ marginBottom: 12 }}>
              <div style={{ fontSize: 11, color: 'var(--accent-orange)', fontFamily: 'var(--mono)', marginBottom: 6 }}>Schematic generation returned invalid SVG.</div>
              <button onClick={handleGenSchematic} disabled={genL} className="btn-primary" style={{ fontSize: 12 }}>{genL ? 'Regenerating...' : '↻ Try Again'}</button>
            </div>
          ) : (
            <button onClick={handleGenSchematic} disabled={genL || !s.tldr} className="btn-primary" style={{ marginBottom: 12, fontSize: 12, opacity: !s.tldr ? 0.4 : 1 }}>{genL ? 'Generating...' : '🎨 Generate Method Schematic'}</button>
          )}

          {/* User-uploaded figure */}
          {p.figure ? (
            <div>
              <div style={{ fontSize: 11, color: 'var(--text-muted)', fontFamily: 'var(--mono)', marginBottom: 6 }}>Key Figure</div>
              <img src={p.figure} alt="Key figure" style={{ maxWidth: '100%', borderRadius: 6, border: '1px solid var(--border)' }} />
              <div style={{ display: 'flex', gap: 8, marginTop: 8 }}>
                <button onClick={() => figRef.current?.click()} className="btn-sec" style={{ fontSize: 11, padding: '4px 10px' }}>Replace</button>
                <button onClick={() => onUpdateFigure(p.id, null)} className="btn-sec" style={{ fontSize: 11, padding: '4px 10px', color: 'var(--accent-red)' }}>Remove</button>
              </div>
            </div>
          ) : (
            <div>
              <button onClick={() => figRef.current?.click()} className="btn-sec" style={{ fontSize: 12 }}>📷 Upload Key Figure</button>
              <span style={{ fontSize: 11, color: 'var(--text-faint)', fontFamily: 'var(--mono)', marginLeft: 8 }}>Screenshot or save a key figure from the paper</span>
            </div>
          )}
          <input ref={figRef} type="file" accept="image/*" onChange={handleFigUpload} style={{ display: 'none' }} />
        </div>

        {/* Info grid */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
          {[{ l: 'Key Contributions', i: s.key_contributions, c: 'var(--accent-green)' }, { l: 'Methods', i: s.methods, c: 'var(--accent-blue)' }, { l: 'Limitations', i: s.limitations, c: 'var(--accent-orange)' }, { l: 'Open Questions', i: s.open_questions, c: 'var(--accent-yellow)' }].map(x => x.i?.length > 0 ? (
            <div key={x.l} className="section-box"><div className="section-label" style={{ color: x.c }}>{x.l}</div>{x.i.map((it, j) => <div key={j} style={{ fontSize: 13, color: '#a0aab5', lineHeight: 1.5, marginBottom: 4, paddingLeft: 10, borderLeft: '2px solid ' + x.c + '33' }}>{it}</div>)}</div>
          ) : null)}
        </div>

        {/* Citations */}
        {s.key_citations_to_follow?.length > 0 && (
          <div className="section-box" style={{ marginTop: 12 }}>
            <div className="section-label" style={{ color: 'var(--accent-purple)' }}>Citations to Follow</div>
            {s.key_citations_to_follow.map((c, i) => { const ct = typeof c === 'object' && c.citation ? c.citation : String(c); const re = typeof c === 'object' ? c.reason : null; const sq = encodeURIComponent(ct.replace(/\d{4}/g, '').replace(/et al/g, '').trim()); return (
              <div key={i} style={{ marginBottom: 10, paddingLeft: 10, borderLeft: '2px solid #9070c433' }}>
                <a href={'https://scholar.google.com/scholar?q=' + sq} target="_blank" rel="noopener" style={{ fontSize: 13, color: '#b0a5d0', textDecoration: 'none', borderBottom: '1px dashed #9070c444' }}>{ct}</a>
                {re && <div style={{ fontSize: 11, color: '#6a6080', marginTop: 2, fontFamily: 'var(--mono)' }}>{re}</div>}
              </div>
            ) })}
          </div>
        )}

        {s.relevance_to_medical_imaging && <div className="section-box" style={{ marginTop: 12, background: '#1a1822', borderColor: '#2a2535' }}><div className="section-label" style={{ color: 'var(--accent-purple)' }}>Relevance to Your Research</div><div style={{ fontSize: 13, color: '#b0a5c0', lineHeight: 1.5 }}>{s.relevance_to_medical_imaging}</div></div>}

        {p.abstract && <details style={{ marginTop: 16 }}><summary style={{ fontSize: 13, color: 'var(--text-muted)', cursor: 'pointer', fontFamily: 'var(--mono)' }}>Full Abstract</summary><div style={{ marginTop: 8, fontSize: 13, color: '#8a95a5', lineHeight: 1.6, padding: '12px 16px', background: '#0e1318', borderRadius: 6 }}>{p.abstract}</div></details>}

        <div style={{ marginTop: 20 }}>
          <div className="section-label">Your Notes</div>
          <textarea value={p.notes || ''} onChange={e => onUpdateNotes(p.id, e.target.value)} placeholder="Add thoughts, connections, TODOs..." style={{ width: '100%', minHeight: 100, padding: '12px 14px', background: '#0e1318', border: '1px solid var(--border)', borderRadius: 6, color: '#b0bac5', fontSize: 13, fontFamily: 'var(--mono)', lineHeight: 1.5, resize: 'vertical', outline: 'none', boxSizing: 'border-box' }} />
        </div>
      </div>
    </div>
  )
}

ENDFILE_src_components_DetailView_jsx

echo 'Creating src/components/GapView.jsx...'
cat > src/components/GapView.jsx << 'ENDFILE_src_components_GapView_jsx'
export default function GapView({ papers, gap, gapL, onRunGap }) {
  const sections = [
    { l: 'Themes', i: gap?.themes, c: 'var(--accent-green)' },
    { l: 'Gaps in Literature', i: gap?.gaps, c: 'var(--accent-red)' },
    { l: 'Contradictions', i: gap?.contradictions, c: 'var(--accent-orange)' },
    { l: 'Suggested Directions', i: gap?.suggested_directions, c: 'var(--accent-blue)' },
    { l: 'Missing Baselines', i: gap?.missing_baselines, c: 'var(--accent-purple)' },
    { l: 'Search Queries to Try', i: gap?.suggested_search_queries, c: '#5bc4b0' },
  ]

  return (
    <div style={{ padding: '20px 32px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 }}>
        <h2 style={{ fontSize: 18, color: 'var(--text-primary)', fontWeight: 400, margin: 0 }}>Gap Analysis</h2>
        <button onClick={onRunGap} disabled={gapL || papers.length < 2} className="btn-primary" style={{ opacity: papers.length < 2 ? 0.4 : 1 }}>{gapL ? 'Analyzing...' : '⚡ Run Gap Analysis'}</button>
      </div>

      {!gap ? (
        <div style={{ textAlign: 'center', padding: 60, color: 'var(--text-faint)', fontFamily: 'var(--mono)' }}>
          <div style={{ fontSize: 40, marginBottom: 12 }}>◇</div>
          Click "⚡ Run Gap Analysis" to identify themes, gaps, and research directions across your {papers.length} papers.
        </div>
      ) : (
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
          {sections.map(x => x.i?.length > 0 ? (
            <div key={x.l} className="section-box">
              <div className="section-label" style={{ color: x.c }}>{x.l}</div>
              {x.i.map((it, j) => (
                <div key={j} style={{ fontSize: 13, color: '#a0aab5', lineHeight: 1.5, marginBottom: 6, paddingLeft: 10, borderLeft: '2px solid ' + x.c + '44' }}>{it}</div>
              ))}
            </div>
          ) : null)}
        </div>
      )}
    </div>
  )
}

ENDFILE_src_components_GapView_jsx

echo 'Creating src/components/GraphView.jsx...'
cat > src/components/GraphView.jsx << 'ENDFILE_src_components_GraphView_jsx'
import { useRef, useEffect, useState, useMemo } from 'react'
import { gtc, tagStyle, computeRelationships, computeClusters } from '../utils'

export default function GraphView({ papers, onSelect }) {
  const withSummary = useMemo(() => papers.filter(p => p.summary), [papers])
  const rels = useMemo(() => computeRelationships(withSummary), [withSummary])
  const { clusters, bridges } = useMemo(() => withSummary.length >= 2 ? computeClusters(withSummary, rels) : { clusters: [], bridges: [] }, [withSummary, rels])
  const [activeTab, setActiveTab] = useState('clusters')
  const COLORS = useMemo(() => ['#5b8a72', '#7eb8da', '#9070c4', '#c49070', '#c4c470', '#c47070', '#7ec4c4', '#c490d1'], [])

  if (withSummary.length < 2) {
    return (
      <div style={{ padding: '20px 32px', textAlign: 'center', paddingTop: 60, color: 'var(--text-faint)', fontFamily: 'var(--mono)' }}>
        Add 2+ papers with summaries to see relationships
      </div>
    )
  }

  const tabStyle = (active) => ({
    padding: '8px 16px', fontSize: 12, fontFamily: 'var(--mono)', cursor: 'pointer',
    background: active ? '#1a2535' : 'transparent', color: active ? 'var(--accent-green-light)' : 'var(--text-faint)',
    border: '1px solid ' + (active ? 'var(--border)' : 'transparent'), borderRadius: 6,
  })

  return (
    <div style={{ padding: '20px 32px' }}>
      <h2 style={{ fontSize: 18, color: 'var(--text-primary)', fontWeight: 400, margin: '0 0 16px' }}>Paper Relationships</h2>
      <div style={{ display: 'flex', gap: 6, marginBottom: 20 }}>
        <span onClick={() => setActiveTab('clusters')} style={tabStyle(activeTab === 'clusters')}>Clusters ({clusters.length})</span>
        <span onClick={() => setActiveTab('connections')} style={tabStyle(activeTab === 'connections')}>Connections ({rels.length})</span>
        <span onClick={() => setActiveTab('graph')} style={tabStyle(activeTab === 'graph')}>Interactive Graph</span>
      </div>

      {activeTab === 'clusters' && <ClustersTab clusters={clusters} bridges={bridges} withSummary={withSummary} onSelect={onSelect} colors={COLORS} />}
      {activeTab === 'connections' && <ConnectionsTab rels={rels} onSelect={onSelect} />}
      {activeTab === 'graph' && <InteractiveGraph papers={withSummary} clusters={clusters} rels={rels} onSelect={onSelect} colors={COLORS} />}
    </div>
  )
}

// ── Clusters Tab ─────────────────────────────────────────────────────────
function ClustersTab({ clusters, bridges, withSummary, onSelect, colors }) {
  if (clusters.length === 0) {
    return <div style={{ fontSize: 13, color: 'var(--text-faint)', fontFamily: 'var(--mono)', padding: 40, textAlign: 'center' }}>No clusters detected yet.</div>
  }
  const clusteredIds = new Set(clusters.flatMap(c => c.papers.map(p => p.id)))
  const unclustered = withSummary.filter(p => !clusteredIds.has(p.id))

  return (
    <div>
      {clusters.map((cluster, ci) => (
        <div key={ci} style={{ background: 'var(--bg-secondary)', border: '1px solid var(--border)', borderRadius: 10, padding: '18px 22px', marginBottom: 16 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 12 }}>
            <div style={{ width: 12, height: 12, borderRadius: '50%', background: colors[ci % colors.length], flexShrink: 0 }} />
            <h3 style={{ fontSize: 15, color: 'var(--text-primary)', fontWeight: 400, margin: 0, flex: 1 }}>{cluster.name}</h3>
            <span style={{ fontSize: 11, color: 'var(--text-muted)', fontFamily: 'var(--mono)' }}>{cluster.size} papers</span>
          </div>
          {cluster.tags.length > 0 && <div style={{ marginBottom: 10 }}>{cluster.tags.map(t => <span key={t} style={tagStyle(t)}>{t}</span>)}</div>}
          {cluster.reasons.length > 0 && <div style={{ fontSize: 11, color: 'var(--text-muted)', fontFamily: 'var(--mono)', marginBottom: 12, padding: '6px 10px', background: 'var(--bg-primary)', borderRadius: 4 }}>Grouped by: {cluster.reasons.slice(0, 4).join(' · ')}</div>}
          {cluster.papers.map(p => (
            <div key={p.id} onClick={() => onSelect(p.id)} style={{ padding: '8px 12px', marginBottom: 4, borderRadius: 6, cursor: 'pointer', borderLeft: '3px solid ' + colors[ci % colors.length] + '44' }}
              onMouseEnter={e => e.currentTarget.style.background = '#1a2030'} onMouseLeave={e => e.currentTarget.style.background = 'transparent'}>
              <div style={{ fontSize: 13, color: 'var(--text-primary)', lineHeight: 1.3 }}>{p.starred && <span style={{ color: '#c4c470', marginRight: 4 }}>★</span>}{p.title}</div>
              <div style={{ fontSize: 11, color: 'var(--text-faint)', fontFamily: 'var(--mono)', marginTop: 2 }}>{(p.authors || []).slice(0, 2).join(', ')}{(p.authors || []).length > 2 ? ' et al.' : ''} · {p.published}</div>
            </div>
          ))}
        </div>
      ))}
      {bridges.length > 0 && (
        <div style={{ marginTop: 20 }}>
          <h3 style={{ fontSize: 14, color: 'var(--accent-purple)', fontWeight: 400, margin: '0 0 12px', fontFamily: 'var(--mono)' }}>Bridge Papers</h3>
          {bridges.map((b, i) => (
            <div key={i} onClick={() => onSelect(b.paper.id)} style={{ background: 'var(--bg-secondary)', border: '1px solid #2a2535', borderRadius: 8, padding: '10px 14px', marginBottom: 6, cursor: 'pointer' }}>
              <div style={{ fontSize: 13, color: 'var(--text-primary)' }}>{b.paper.title}</div>
              <div style={{ fontSize: 11, color: '#9070c4', fontFamily: 'var(--mono)', marginTop: 4 }}>Connects: {b.clusters.join(' ↔ ')}</div>
            </div>
          ))}
        </div>
      )}
      {unclustered.length > 0 && (
        <div style={{ marginTop: 20 }}>
          <h3 style={{ fontSize: 14, color: 'var(--text-muted)', fontWeight: 400, margin: '0 0 12px', fontFamily: 'var(--mono)' }}>Unclustered ({unclustered.length})</h3>
          {unclustered.map(p => (
            <div key={p.id} onClick={() => onSelect(p.id)} style={{ padding: '6px 12px', fontSize: 13, color: 'var(--text-faint)', cursor: 'pointer', marginBottom: 4 }}
              onMouseEnter={e => e.currentTarget.style.color = 'var(--text-primary)'} onMouseLeave={e => e.currentTarget.style.color = 'var(--text-faint)'}>{p.title}</div>
          ))}
        </div>
      )}
    </div>
  )
}

// ── Connections Tab ───────────────────────────────────────────────────────
function ConnectionsTab({ rels, onSelect }) {
  if (rels.length === 0) return <div style={{ fontSize: 13, color: 'var(--text-faint)', fontFamily: 'var(--mono)', padding: 40, textAlign: 'center' }}>No connections found.</div>
  return (
    <div>
      {rels.slice(0, 30).map((r, i) => (
        <div key={i} style={{ background: 'var(--bg-secondary)', border: '1px solid var(--border)', borderRadius: 8, padding: '12px 16px', marginBottom: 8 }}>
          <div style={{ display: 'flex', gap: 8, alignItems: 'center', marginBottom: 6 }}>
            <span style={{ fontSize: 13, color: 'var(--text-primary)', flex: 1, cursor: 'pointer' }} onClick={() => onSelect(r.a)}>{r.aTitle?.length > 50 ? r.aTitle.slice(0, 50) + '...' : r.aTitle}</span>
            <span style={{ fontSize: 11, color: 'var(--accent-green)', fontFamily: 'var(--mono)', flexShrink: 0 }}>↔</span>
            <span style={{ fontSize: 13, color: 'var(--text-primary)', flex: 1, cursor: 'pointer', textAlign: 'right' }} onClick={() => onSelect(r.b)}>{r.bTitle?.length > 50 ? r.bTitle.slice(0, 50) + '...' : r.bTitle}</span>
          </div>
          <div style={{ fontSize: 11, color: 'var(--text-muted)', fontFamily: 'var(--mono)' }}>{r.reasons.join(' · ')}</div>
        </div>
      ))}
    </div>
  )
}

// ── Interactive Graph with Zoom + Pan + Tooltips ─────────────────────────
function InteractiveGraph({ papers, clusters, rels, onSelect, colors }) {
  const canvasRef = useRef(null)
  const tooltipRef = useRef(null)
  const nodesRef = useRef([])
  const edgesRef = useRef([])
  const viewRef = useRef({ x: 0, y: 0, scale: 1 })
  const dragRef = useRef({ dragging: false, startX: 0, startY: 0, startViewX: 0, startViewY: 0 })
  const hoveredRef = useRef(null)

  // Build cluster color map (only when clusters change)
  const clusterMap = useMemo(() => {
    const m = {}
    clusters.forEach((c, ci) => { c.papers.forEach(p => { m[p.id] = ci }) })
    return m
  }, [clusters])

  // Initialize nodes and run force simulation
  useEffect(() => {
    const nodes = papers.map((p, i) => {
      const angle = (2 * Math.PI * i) / papers.length
      const r = Math.min(280, papers.length * 20)
      const ci = clusterMap[p.id]
      return { id: p.id, title: p.title, color: ci !== undefined ? colors[ci % colors.length] : '#3a4555', x: 400 + r * Math.cos(angle), y: 320 + r * Math.sin(angle), vx: 0, vy: 0 }
    })
    // Build edge lookup map for O(1) access
    const edgeList = rels.filter(r => r.strength >= 1).map(r => ({ source: r.a, target: r.b, strength: r.strength, reasons: r.reasons }))
    const nodeMap = {}
    nodes.forEach(n => { nodeMap[n.id] = n })

    // Force simulation — use nodeMap for O(1) lookups
    for (let iter = 0; iter < 100; iter++) {
      for (let i = 0; i < nodes.length; i++) {
        for (let j = i + 1; j < nodes.length; j++) {
          const dx = nodes[j].x - nodes[i].x, dy = nodes[j].y - nodes[i].y
          const dist = Math.max(Math.sqrt(dx * dx + dy * dy), 1)
          const f = 1000 / (dist * dist)
          nodes[i].vx -= (dx / dist) * f; nodes[i].vy -= (dy / dist) * f
          nodes[j].vx += (dx / dist) * f; nodes[j].vy += (dy / dist) * f
        }
      }
      for (const e of edgeList) {
        const s = nodeMap[e.source], t = nodeMap[e.target]
        if (!s || !t) continue
        const dx = t.x - s.x, dy = t.y - s.y, dist = Math.max(Math.sqrt(dx * dx + dy * dy), 1)
        const f = (dist - 160) * 0.01 * e.strength
        s.vx += (dx / dist) * f; s.vy += (dy / dist) * f
        t.vx -= (dx / dist) * f; t.vy -= (dy / dist) * f
      }
      for (const n of nodes) {
        n.vx += (400 - n.x) * 0.008; n.vy += (320 - n.y) * 0.008
        n.x += n.vx * 0.3; n.y += n.vy * 0.3; n.vx *= 0.75; n.vy *= 0.75
      }
    }
    nodesRef.current = nodes; edgesRef.current = edgeList
    viewRef.current = { x: 0, y: 0, scale: 1 }
    draw()
  }, [papers, clusterMap, rels])

  function draw() {
    const canvas = canvasRef.current; if (!canvas) return
    const ctx = canvas.getContext('2d')
    const W = 800, H = 640
    const { x: vx, y: vy, scale } = viewRef.current
    const nodes = nodesRef.current, edges = edgesRef.current
    const hid = hoveredRef.current

    ctx.clearRect(0, 0, W, H); ctx.fillStyle = '#0a0e13'; ctx.fillRect(0, 0, W, H)
    ctx.save(); ctx.translate(vx, vy); ctx.scale(scale, scale)

    // Build connected set for hovered node (once per draw, not per edge)
    const connectedIds = new Set()
    if (hid) { edges.forEach(e => { if (e.source === hid) connectedIds.add(e.target); if (e.target === hid) connectedIds.add(e.source) }) }

    for (const e of edges) {
      const s = nodes.find(n => n.id === e.source), t = nodes.find(n => n.id === e.target)
      if (!s || !t) continue
      const isHL = hid && (e.source === hid || e.target === hid)
      ctx.beginPath(); ctx.moveTo(s.x, s.y); ctx.lineTo(t.x, t.y)
      ctx.strokeStyle = isHL ? '#4a8a5a' : (e.strength >= 3 ? '#2a5a3a' : e.strength >= 2 ? '#1e3a2e' : '#162520')
      ctx.lineWidth = isHL ? Math.min(e.strength + 1, 4) : Math.min(e.strength, 3); ctx.stroke()
      if (isHL && e.reasons) {
        const mx = (s.x + t.x) / 2, my = (s.y + t.y) / 2
        ctx.fillStyle = '#6a8a7a'; ctx.font = '8px Arial'; ctx.textAlign = 'center'
        ctx.fillText(e.reasons[0] || '', mx, my - 4)
      }
    }

    for (const n of nodes) {
      const isH = hid === n.id
      const isConn = hid ? connectedIds.has(n.id) : false
      const radius = isH ? 14 : (isConn ? 11 : 8)
      ctx.globalAlpha = hid ? (isH || isConn ? 1 : 0.3) : 1
      if (isH) { ctx.beginPath(); ctx.arc(n.x, n.y, 20, 0, Math.PI * 2); ctx.fillStyle = n.color + '30'; ctx.fill() }
      ctx.beginPath(); ctx.arc(n.x, n.y, radius, 0, Math.PI * 2)
      ctx.fillStyle = n.color; ctx.fill()
      ctx.strokeStyle = isH ? '#ffffff' : '#c0c0c0'; ctx.lineWidth = isH ? 2.5 : 1; ctx.stroke()
      ctx.fillStyle = isH || isConn ? '#d4dae0' : '#6a7b8f'
      ctx.font = (isH ? 'bold 11px' : '10px') + ' Arial'; ctx.textAlign = 'center'
      ctx.fillText(n.title.length > 32 ? n.title.slice(0, 32) + '...' : n.title, n.x, n.y + radius + 14)
      ctx.globalAlpha = 1
    }

    ctx.restore()
    ctx.fillStyle = '#3a4555'; ctx.font = '10px monospace'; ctx.textAlign = 'right'
    ctx.fillText('Zoom: ' + Math.round(scale * 100) + '%  |  Scroll to zoom  |  Drag to pan', W - 10, H - 8)
  }

  function screenToGraph(sx, sy) {
    const rect = canvasRef.current.getBoundingClientRect()
    const cx = (sx - rect.left) * (800 / rect.width), cy = (sy - rect.top) * (640 / rect.height)
    const { x: vx, y: vy, scale } = viewRef.current
    return { x: (cx - vx) / scale, y: (cy - vy) / scale }
  }

  function findNode(e) {
    if (!canvasRef.current) return null
    const { x, y } = screenToGraph(e.clientX, e.clientY)
    return nodesRef.current.find(n => Math.sqrt((n.x - x) ** 2 + (n.y - y) ** 2) < 16)
  }

  function updateTooltip(e, node) {
    const el = tooltipRef.current; if (!el) return
    if (!node) { el.style.display = 'none'; return }
    const rect = canvasRef.current.getBoundingClientRect()
    const tx = Math.min(e.clientX - rect.left + 15, 520)
    const ty = e.clientY - rect.top - 10
    const connected = edgesRef.current.filter(ed => ed.source === node.id || ed.target === node.id)
    let html = '<div style="font-size:13px;color:#e8e8e8;font-weight:bold;margin-bottom:6px;line-height:1.3">' + node.title + '</div>'
    if (connected.length > 0) {
      html += '<div style="font-size:10px;color:#7ec49e;font-family:monospace;margin-bottom:4px;text-transform:uppercase">Connected to:</div>'
      connected.slice(0, 5).forEach(c => {
        const otherId = c.source === node.id ? c.target : c.source
        const other = nodesRef.current.find(nd => nd.id === otherId)
        const title = other ? (other.title.length > 45 ? other.title.slice(0, 45) + '...' : other.title) : '?'
        html += '<div style="margin-bottom:4px;padding-left:8px;border-left:2px solid #2a4a39"><div style="font-size:11px;color:#b0bac5;line-height:1.2">' + title + '</div><div style="font-size:9px;color:#5a6a7a;font-family:monospace">' + (c.reasons || []).slice(0, 2).join(' · ') + '</div></div>'
      })
      if (connected.length > 5) html += '<div style="font-size:10px;color:#4a5a6a;font-family:monospace">+' + (connected.length - 5) + ' more</div>'
    } else {
      html += '<div style="font-size:11px;color:#4a5a6a;font-family:monospace">No direct connections</div>'
    }
    el.innerHTML = html
    el.style.display = 'block'; el.style.left = tx + 'px'; el.style.top = ty + 'px'
  }

  function handleMouseMove(e) {
    if (dragRef.current.dragging) {
      viewRef.current.x = dragRef.current.startViewX + (e.clientX - dragRef.current.startX)
      viewRef.current.y = dragRef.current.startViewY + (e.clientY - dragRef.current.startY)
      draw(); return
    }
    const n = findNode(e)
    const newId = n ? n.id : null
    if (newId !== hoveredRef.current) { hoveredRef.current = newId; draw() }
    if (canvasRef.current) canvasRef.current.style.cursor = n ? 'pointer' : 'grab'
    updateTooltip(e, n)
  }

  function handleMouseDown(e) {
    if (!findNode(e)) {
      dragRef.current = { dragging: true, startX: e.clientX, startY: e.clientY, startViewX: viewRef.current.x, startViewY: viewRef.current.y }
      if (canvasRef.current) canvasRef.current.style.cursor = 'grabbing'
    }
  }

  function handleMouseUp(e) {
    if (!dragRef.current.dragging) { const n = findNode(e); if (n) onSelect(n.id) }
    dragRef.current.dragging = false
    if (canvasRef.current) canvasRef.current.style.cursor = 'grab'
  }

  function handleWheel(e) {
    e.preventDefault()
    const rect = canvasRef.current.getBoundingClientRect()
    const mx = (e.clientX - rect.left) * (800 / rect.width), my = (e.clientY - rect.top) * (640 / rect.height)
    const delta = e.deltaY > 0 ? 0.9 : 1.1
    const newScale = Math.max(0.3, Math.min(4, viewRef.current.scale * delta))
    viewRef.current.x = mx - (mx - viewRef.current.x) * (newScale / viewRef.current.scale)
    viewRef.current.y = my - (my - viewRef.current.y) * (newScale / viewRef.current.scale)
    viewRef.current.scale = newScale; draw()
  }

  return (
    <div style={{ position: 'relative' }}>
      <canvas ref={canvasRef} width={800} height={640}
        onMouseMove={handleMouseMove} onMouseDown={handleMouseDown} onMouseUp={handleMouseUp}
        onMouseLeave={() => { dragRef.current.dragging = false; hoveredRef.current = null; draw(); if (tooltipRef.current) tooltipRef.current.style.display = 'none' }}
        onWheel={handleWheel}
        style={{ width: '100%', maxWidth: 800, height: 'auto', borderRadius: 8, border: '1px solid var(--border)', cursor: 'grab' }} />
      {/* Tooltip — updated via DOM ref, no React re-renders */}
      <div ref={tooltipRef} style={{ display: 'none', position: 'absolute', background: '#151d28', border: '1px solid #2a3545', borderRadius: 8, padding: '10px 14px', maxWidth: 300, pointerEvents: 'none', zIndex: 10, boxShadow: '0 4px 20px rgba(0,0,0,0.5)' }} />
      {clusters.length > 0 && (
        <div style={{ marginTop: 10, display: 'flex', gap: 12, flexWrap: 'wrap', fontSize: 11, fontFamily: 'var(--mono)', color: 'var(--text-faint)' }}>
          {clusters.map((c, i) => <span key={i} style={{ display: 'flex', alignItems: 'center', gap: 4 }}><span style={{ width: 8, height: 8, borderRadius: '50%', background: colors[i % colors.length], display: 'inline-block' }} />{c.name}</span>)}
          <span style={{ display: 'flex', alignItems: 'center', gap: 4 }}><span style={{ width: 8, height: 8, borderRadius: '50%', background: '#3a4555', display: 'inline-block' }} />Unclustered</span>
        </div>
      )}
    </div>
  )
}

ENDFILE_src_components_GraphView_jsx

echo 'Creating src/components/LibraryView.jsx...'
cat > src/components/LibraryView.jsx << 'ENDFILE_src_components_LibraryView_jsx'
import { useState } from 'react'
import { tagStyle, getPaperUrl } from '../utils'

export default function LibraryView({ papers, filtered, allTags, filterTags, setFilterTags, readFilter, setReadFilter, search, setSearch, unsum, sumL, loadingMsg, onSumAll, onSelect, onToggleStar, showStarred, setShowStarred, weeklyRecs, weeklyL, onGenWeekly }) {
  const starredCount = papers.filter(p => p.starred).length
  const readCount = papers.filter(p => p.readStatus === 'read').length
  const unreadCount = papers.length - readCount
  const [showWeekly, setShowWeekly] = useState(!!weeklyRecs)

  function toggleTag(tag) {
    setFilterTags(prev => prev.includes(tag) ? prev.filter(t => t !== tag) : [...prev, tag])
  }

  const readBtnStyle = (active) => ({
    padding: '4px 10px', fontSize: 11, fontFamily: 'var(--mono)', cursor: 'pointer',
    background: active ? '#1a2535' : 'transparent',
    color: active ? 'var(--accent-green-light)' : 'var(--text-faint)',
    border: '1px solid ' + (active ? '#2a4a39' : '#1e2a3a'),
    borderRadius: 4,
  })

  return (
    <div style={{ padding: '20px 32px' }}>
      {/* Stats bar */}
      <div style={{ display: 'flex', gap: 10, marginBottom: 20, flexWrap: 'wrap', alignItems: 'center' }}>
        <span className="stat">{papers.length} papers</span>
        <span className="stat" style={{ cursor: 'pointer', color: readFilter === 'read' ? 'var(--accent-green-light)' : 'var(--text-muted)' }}
          onClick={() => setReadFilter(readFilter === 'read' ? 'all' : 'read')}>{readCount} read</span>
        <span className="stat" style={{ cursor: 'pointer', color: readFilter === 'unread' ? 'var(--accent-orange)' : 'var(--text-muted)' }}
          onClick={() => setReadFilter(readFilter === 'unread' ? 'all' : 'unread')}>{unreadCount} unread</span>
        {starredCount > 0 && <span className="stat" onClick={() => setShowStarred(!showStarred)} style={{ cursor: 'pointer', color: showStarred ? '#c4c470' : 'var(--text-muted)', border: showStarred ? '1px solid #3a3a20' : undefined }}>★ {starredCount}</span>}
        <span className="stat">{allTags.length} tags</span>
        <div style={{ flex: 1 }} />
        <button onClick={() => { if (weeklyRecs) setShowWeekly(!showWeekly); else onGenWeekly() }} disabled={weeklyL} className="btn-sec" style={{ color: 'var(--accent-purple)', borderColor: '#2a2040', fontSize: 12 }}>{weeklyL ? 'Thinking...' : '📚 Weekly Reading'}</button>
        {unsum > 0 && <button onClick={onSumAll} disabled={sumL} className="btn-primary" style={{ background: '#1a2a33', color: 'var(--accent-blue)', borderColor: '#2a4a5a' }}>{sumL ? loadingMsg || 'Summarizing...' : '⚡ Summarize All (' + unsum + ')'}</button>}
      </div>

      {/* Weekly Reading Panel */}
      {showWeekly && weeklyRecs && (
        <div style={{ background: '#151020', border: '1px solid #2a2040', borderRadius: 10, padding: '18px 22px', marginBottom: 20 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
            <h3 style={{ fontSize: 15, color: 'var(--accent-purple)', fontWeight: 400, margin: 0, fontFamily: 'var(--mono)' }}>📚 Weekly Reading Suggestions</h3>
            <div style={{ display: 'flex', gap: 8 }}>
              <button onClick={onGenWeekly} disabled={weeklyL} className="btn-sec" style={{ fontSize: 10, padding: '3px 8px', color: 'var(--accent-purple)' }}>{weeklyL ? '...' : '↻ Refresh'}</button>
              <span onClick={() => setShowWeekly(false)} style={{ cursor: 'pointer', color: 'var(--text-muted)', fontSize: 14 }}>✕</span>
            </div>
          </div>

          {/* Theme */}
          {weeklyRecs.theme_of_the_week && (
            <div style={{ fontSize: 14, color: '#c4b0e0', lineHeight: 1.4, marginBottom: 14, padding: '8px 12px', background: '#1a1530', borderRadius: 6, borderLeft: '3px solid #9070c4' }}>
              {weeklyRecs.theme_of_the_week}
            </div>
          )}

          {/* From your library */}
          {weeklyRecs.from_library?.length > 0 && (
            <div style={{ marginBottom: 14 }}>
              <div style={{ fontSize: 11, color: 'var(--accent-green)', fontFamily: 'var(--mono)', marginBottom: 8, textTransform: 'uppercase' }}>From your library</div>
              {weeklyRecs.from_library.map((rec, i) => {
                const match = papers.find(p => p.title?.toLowerCase() === rec.title?.toLowerCase())
                return (
                  <div key={i} onClick={() => { if (match) onSelect(match) }}
                    style={{ padding: '8px 12px', marginBottom: 4, borderRadius: 6, cursor: match ? 'pointer' : 'default', borderLeft: '3px solid ' + (rec.priority === 'high' ? '#5b8a72' : '#3a5a4a'), transition: 'background 0.15s' }}
                    onMouseEnter={e => e.currentTarget.style.background = '#1a2030'}
                    onMouseLeave={e => e.currentTarget.style.background = 'transparent'}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                      {rec.priority === 'high' && <span style={{ fontSize: 9, color: '#5b8a72', fontFamily: 'var(--mono)', background: '#1a2e1a', padding: '1px 5px', borderRadius: 3 }}>HIGH</span>}
                      <span style={{ fontSize: 13, color: 'var(--text-primary)', lineHeight: 1.3 }}>{rec.title}</span>
                    </div>
                    <div style={{ fontSize: 11, color: 'var(--text-muted)', fontFamily: 'var(--mono)', marginTop: 3 }}>{rec.reason}</div>
                  </div>
                )
              })}
            </div>
          )}

          {/* New papers to search for */}
          {weeklyRecs.new_suggestions?.length > 0 && (
            <div style={{ marginBottom: 10 }}>
              <div style={{ fontSize: 11, color: 'var(--accent-blue)', fontFamily: 'var(--mono)', marginBottom: 8, textTransform: 'uppercase' }}>New papers to explore</div>
              {weeklyRecs.new_suggestions.map((sug, i) => (
                <div key={i} style={{ padding: '8px 12px', marginBottom: 4, borderRadius: 6, borderLeft: '3px solid #1e3a5a' }}>
                  <div style={{ fontSize: 12, color: '#7eb8da', fontFamily: 'var(--mono)' }}>{sug.topic}</div>
                  <div style={{ fontSize: 11, color: 'var(--text-muted)', marginTop: 2 }}>{sug.reason}</div>
                  <a href={'https://scholar.google.com/scholar?q=' + encodeURIComponent(sug.search_query)} target="_blank" rel="noopener"
                    style={{ fontSize: 10, color: 'var(--accent-blue)', fontFamily: 'var(--mono)', textDecoration: 'none', marginTop: 4, display: 'inline-block' }}>
                    Search: {sug.search_query} →
                  </a>
                </div>
              ))}
            </div>
          )}

          {/* Reading order tip */}
          {weeklyRecs.reading_order_tip && (
            <div style={{ fontSize: 11, color: '#6a5a7a', fontFamily: 'var(--mono)', padding: '6px 10px', background: '#120e1a', borderRadius: 4 }}>
              💡 {weeklyRecs.reading_order_tip}
            </div>
          )}

          {weeklyRecs.generatedAt && (
            <div style={{ fontSize: 10, color: '#3a3050', fontFamily: 'var(--mono)', marginTop: 8 }}>Generated {new Date(weeklyRecs.generatedAt).toLocaleDateString()}</div>
          )}
        </div>
      )}

      {/* Search + active filters */}
      <div style={{ display: 'flex', gap: 10, marginBottom: 12, flexWrap: 'wrap', alignItems: 'center' }}>
        <input value={search} onChange={e => setSearch(e.target.value)} placeholder="Search papers..." className="text-input" style={{ flex: 1, minWidth: 200 }} />
        <div style={{ display: 'flex', gap: 4 }}>
          <span onClick={() => setReadFilter('all')} style={readBtnStyle(readFilter === 'all')}>All</span>
          <span onClick={() => setReadFilter('read')} style={readBtnStyle(readFilter === 'read')}>✓ Read</span>
          <span onClick={() => setReadFilter('unread')} style={readBtnStyle(readFilter === 'unread')}>○ Unread</span>
        </div>
      </div>

      {/* Active filter badges */}
      {(filterTags.length > 0 || showStarred || readFilter !== 'all') && (
        <div style={{ display: 'flex', gap: 6, marginBottom: 12, flexWrap: 'wrap', alignItems: 'center' }}>
          <span style={{ fontSize: 11, color: 'var(--text-faint)', fontFamily: 'var(--mono)', marginRight: 4 }}>Active filters:</span>
          {filterTags.map(t => <span key={t} onClick={() => toggleTag(t)} style={{ ...tagStyle(t), cursor: 'pointer', paddingRight: 12, position: 'relative' }}>{t} <span style={{ position: 'absolute', right: 3, top: 0, fontSize: 9, opacity: 0.6 }}>✕</span></span>)}
          {showStarred && <span onClick={() => setShowStarred(false)} style={{ padding: '2px 8px', borderRadius: 3, fontSize: 11, fontFamily: 'var(--mono)', background: '#2a2a1a', color: '#c4c470', cursor: 'pointer' }}>★ Starred ✕</span>}
          {readFilter !== 'all' && <span onClick={() => setReadFilter('all')} style={{ padding: '2px 8px', borderRadius: 3, fontSize: 11, fontFamily: 'var(--mono)', background: readFilter === 'read' ? '#1a2a1a' : '#2a1a15', color: readFilter === 'read' ? 'var(--accent-green)' : 'var(--accent-orange)', cursor: 'pointer' }}>{readFilter === 'read' ? '✓ Read' : '○ Unread'} ✕</span>}
          <span onClick={() => { setFilterTags([]); setShowStarred(false); setReadFilter('all') }} style={{ fontSize: 11, color: 'var(--accent-red)', fontFamily: 'var(--mono)', cursor: 'pointer', marginLeft: 4 }}>Clear all</span>
        </div>
      )}

      {/* Tag cloud */}
      {allTags.length > 0 && (
        <div style={{ marginBottom: 16 }}>
          {allTags.map(t => {
            const isActive = filterTags.includes(t)
            return <span key={t} onClick={() => toggleTag(t)}
              style={{ ...tagStyle(t), cursor: 'pointer', opacity: filterTags.length > 0 && !isActive ? 0.4 : 1, outline: isActive ? '1.5px solid ' + tagStyle(t).color : 'none', outlineOffset: 1 }}>{t}</span>
          })}
        </div>
      )}

      {/* Paper list */}
      {filtered.length === 0 ? (
        <div style={{ textAlign: 'center', padding: '60px 20px', color: 'var(--text-faint)' }}>
          <div style={{ fontSize: 40, marginBottom: 12 }}>◇</div>
          <div style={{ fontSize: 14, fontFamily: 'var(--mono)' }}>{papers.length === 0 ? 'Add papers, import BibTeX/CSV, or sync Zotero via ⚙' : 'No papers match your filters'}</div>
        </div>
      ) : (
        <div>
          <div style={{ fontSize: 11, color: 'var(--text-faint)', fontFamily: 'var(--mono)', marginBottom: 8 }}>Showing {filtered.length} of {papers.length}</div>
          {filtered.map(p => {
            const pUrl = getPaperUrl(p)
            return (
              <div key={p.id} className="paper-card" style={{ display: 'flex', gap: 0 }}>
                <div onClick={(e) => { e.stopPropagation(); onToggleStar(p.id) }}
                  style={{ padding: '18px 12px 18px 4px', cursor: 'pointer', fontSize: 16, color: p.starred ? '#c4c470' : '#2a3545', flexShrink: 0, transition: 'color 0.15s' }}
                  onMouseEnter={e => { if (!p.starred) e.currentTarget.style.color = '#6a6a30' }}
                  onMouseLeave={e => { if (!p.starred) e.currentTarget.style.color = '#2a3545' }}>
                  {p.starred ? '★' : '☆'}
                </div>
                <div style={{ flex: 1, cursor: 'pointer' }} onClick={() => onSelect(p)}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 12 }}>
                    <div style={{ flex: 1 }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 4 }}>
                        {p.readStatus === 'read' && <span style={{ color: 'var(--accent-green)', fontSize: 13 }}>✓</span>}
                        {!p.summary && <span style={{ color: 'var(--accent-orange)', fontSize: 13 }}>○</span>}
                        <span style={{ fontSize: 15, color: '#d4dae0', lineHeight: 1.4 }}>{p.title}</span>
                      </div>
                      <div style={{ fontSize: 12, color: 'var(--text-faint)', fontFamily: 'var(--mono)', marginBottom: 6 }}>{(p.authors || []).slice(0, 3).join(', ')}{(p.authors || []).length > 3 ? ' et al.' : ''} · {p.published}</div>
                      {p.summary?.tldr && <div style={{ fontSize: 13, color: '#7a8a9a', lineHeight: 1.4, marginBottom: 6 }}>{p.summary.tldr}</div>}
                      <div style={{ display: 'flex', gap: 4, flexWrap: 'wrap', alignItems: 'center' }}>
                        {(p.summary?.tags || []).map(t => <span key={t} style={tagStyle(t)}>{t}</span>)}
                        {p.figure && <span style={{ fontSize: 10, color: 'var(--accent-blue)', fontFamily: 'var(--mono)' }}>📷</span>}
                        {p.schematic && <span style={{ fontSize: 10, color: 'var(--accent-purple)', fontFamily: 'var(--mono)' }}>🎨</span>}
                        {pUrl && <a href={pUrl} target="_blank" rel="noopener" onClick={e => e.stopPropagation()} style={{ fontSize: 11, color: 'var(--accent-blue)', fontFamily: 'var(--mono)', textDecoration: 'none', marginLeft: 4 }}>🔗</a>}
                      </div>
                    </div>
                    {p.figure && <img src={p.figure} alt="" style={{ width: 60, height: 45, objectFit: 'cover', borderRadius: 4, border: '1px solid var(--border)', flexShrink: 0 }} />}
                    <div style={{ fontSize: 11, color: 'var(--text-faint)', fontFamily: 'var(--mono)', whiteSpace: 'nowrap' }}>{p.source}</div>
                  </div>
                </div>
              </div>
            )
          })}
        </div>
      )}
    </div>
  )
}

ENDFILE_src_components_LibraryView_jsx

echo 'Creating api/_helpers.js...'
cat > api/_helpers.js << 'ENDFILE_api__helpers_js'
import { createClient } from '@supabase/supabase-js'

const SUPABASE_URL = process.env.SUPABASE_URL
const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY

const FREE_LIMITS = { summary: 5, gap: 2, schematic: 3, weekly: 2 }

// Call Claude API
export async function callClaude(prompt, maxTokens = 1500) {
  const key = process.env.ANTHROPIC_API_KEY
  if (!key) throw new Error('Server misconfigured')
  const r = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'x-api-key': key, 'anthropic-version': '2023-06-01' },
    body: JSON.stringify({ model: 'claude-sonnet-4-20250514', max_tokens: maxTokens, messages: [{ role: 'user', content: prompt }] }),
  })
  if (!r.ok) { const e = await r.json().catch(() => ({})); throw new Error(e.error?.message || 'Claude API error ' + r.status) }
  const d = await r.json()
  return (d.content || []).map(b => b.text || '').join('').replace(/```json/g, '').replace(/```/g, '').trim()
}

// Verify user token and get usage
async function verifyAndGetUsage(token) {
  if (!SUPABASE_URL || !SUPABASE_ANON_KEY) throw new Error('Server misconfigured — missing Supabase config')

  // Create client authenticated as the user
  const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
    global: { headers: { Authorization: 'Bearer ' + token } }
  })

  // Verify user
  const { data: userData, error: userError } = await supabase.auth.getUser(token)
  if (userError || !userData?.user) throw new Error('Not authenticated')

  // Get usage
  const { data: usage, error: usageError } = await supabase.from('usage').select('*').eq('user_id', userData.user.id).single()
  if (usageError || !usage) throw new Error('Could not load usage data')

  return { user: userData.user, usage, supabase }
}

// Check if user can perform an action
function checkLimit(usage, actionType) {
  if (usage.tier === 'pro') return true // Pro users have no limits
  const countField = actionType + '_count'
  const current = usage[countField] || 0
  const limit = FREE_LIMITS[actionType]
  if (limit !== undefined && current >= limit) {
    throw new Error('Free tier limit reached (' + current + '/' + limit + ' ' + actionType + 's). Upgrade to Pro for unlimited access.')
  }
  return true
}

// Increment usage counter
async function incrementUsage(supabase, userId, actionType) {
  const countField = actionType + '_count'
  const { data: current } = await supabase.from('usage').select(countField).eq('user_id', userId).single()
  const newCount = ((current && current[countField]) || 0) + 1
  await supabase.from('usage').update({ [countField]: newCount, updated_at: new Date().toISOString() }).eq('user_id', userId)
}

// CORS headers
export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
}

// Handler wrapper with auth
export function handler(actionType, fn) {
  return async (req, res) => {
    // CORS preflight
    if (req.method === 'OPTIONS') {
      Object.entries(corsHeaders).forEach(([k, v]) => res.setHeader(k, v))
      return res.status(200).end()
    }
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' })
    Object.entries(corsHeaders).forEach(([k, v]) => res.setHeader(k, v))

    try {
      // Extract token from Authorization header
      const authHeader = req.headers.authorization || ''
      const token = authHeader.replace('Bearer ', '').trim()
      if (!token) throw new Error('Login required. Please sign in to use AI features.')

      // Verify user and check usage
      const { user, usage, supabase } = await verifyAndGetUsage(token)
      checkLimit(usage, actionType)

      // Run the actual function
      const result = await fn(req.body)

      // Increment usage after success
      await incrementUsage(supabase, user.id, actionType)

      return res.status(200).json(result)
    } catch (err) {
      console.error('API error:', err.message)
      const status = err.message.includes('Not authenticated') || err.message.includes('Login required') ? 401
        : err.message.includes('limit reached') ? 403
        : 500
      return res.status(status).json({ error: err.message })
    }
  }
}

ENDFILE_api__helpers_js

echo 'Creating api/summarize.js...'
cat > api/summarize.js << 'ENDFILE_api_summarize_js'
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

ENDFILE_api_summarize_js

echo 'Creating api/gap.js...'
cat > api/gap.js << 'ENDFILE_api_gap_js'
import { callClaude, handler } from './_helpers.js'

export default handler('gap', async (body) => {
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

ENDFILE_api_gap_js

echo 'Creating api/schematic.js...'
cat > api/schematic.js << 'ENDFILE_api_schematic_js'
import { callClaude, handler } from './_helpers.js'

export default handler('schematic', async (body) => {
  const { title, abstract, methods, contributions } = body
  if (!title) throw new Error('Title required')
  const svg = await callClaude(`You are an expert scientific diagram designer. Create a CLEAN, PROFESSIONAL SVG pipeline/architecture diagram for this paper.
Title: ${title}\nAbstract: ${abstract || 'N/A'}\nMethods: ${methods || 'N/A'}\nKey contributions: ${contributions || 'N/A'}
STRICT RULES:
1. Return ONLY raw SVG code. No markdown, no backticks.
2. Start with <svg viewBox="0 0 700 350" xmlns="http://www.w3.org/2000/svg"> end with </svg>
3. LEFT-TO-RIGHT flow, 3-6 stages, evenly spaced.
4. BOXES: <rect> rx="8" ry="8", width 100-130, height 50-65.
5. COLORS: Input fill="#1a3329" stroke="#5b8a72", Processing fill="#1a2535" stroke="#7eb8da", Key Method fill="#251a35" stroke="#9070c4", Output fill="#2e2a1a" stroke="#d1c490", Loss fill="#2e1a1a" stroke="#d19090"
6. TEXT: fill="#e8e8e8" font-family="Arial,sans-serif", labels font-size="12" bold, sub-labels font-size="9" fill="#8a9bb5"
7. ARROWS: stroke="#4a5a6a" stroke-width="2" with arrowhead in <defs>
8. Title at top: font-size="14" fill="#e8e8e8" bold
9. BACKGROUND: <rect width="700" height="350" fill="#0e1318" rx="8"/>
10. Center boxes around y=160.`, 3000)
  return { schematic: svg.trim() }
})

ENDFILE_api_schematic_js

echo 'Creating api/weekly.js...'
cat > api/weekly.js << 'ENDFILE_api_weekly_js'
import { callClaude, handler } from './_helpers.js'

export default handler('weekly', async (body) => {
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

ENDFILE_api_weekly_js

echo 'Creating api/extract-pdf.js...'
cat > api/extract-pdf.js << 'ENDFILE_api_extract-pdf_js'
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

ENDFILE_api_extract-pdf_js

echo 'Creating api/lookup.js...'
cat > api/lookup.js << 'ENDFILE_api_lookup_js'
export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type')
  if (req.method === 'OPTIONS') return res.status(200).end()
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' })

  const { type, query } = req.body
  if (!type || !query) return res.status(400).json({ error: 'type and query required' })

  try {
    if (type === 'arxiv') {
      const r = await fetch('https://export.arxiv.org/api/query?id_list=' + encodeURIComponent(query))
      if (!r.ok) throw new Error('arXiv error ' + r.status)
      const xml = await r.text()
      return res.status(200).json({ xml })
    }

    if (type === 'doi') {
      const r = await fetch('https://api.crossref.org/works/' + encodeURIComponent(query), {
        signal: AbortSignal.timeout(15000)
      })
      if (!r.ok) throw new Error('DOI not found in Crossref')
      const data = await r.json()
      const di = data.message
      return res.status(200).json({
        title: (di.title || ['?'])[0],
        abstract: (di.abstract || '').replace(/<[^>]+>/g, ''),
        authors: (di.author || []).map(a => ((a.given || '') + ' ' + (a.family || '')).trim()),
        published: di.published?.['date-parts']?.[0]?.join('-') || '',
        venue: (di['container-title'] || [''])[0],
      })
    }

    if (type === 'search') {
      const r = await fetch('https://api.semanticscholar.org/graph/v1/paper/search?query=' + encodeURIComponent(query) + '&limit=1&fields=title,abstract,authors,year,externalIds,venue')
      if (r.status === 429) throw new Error('Search rate limited. Wait a minute and try again.')
      if (!r.ok) throw new Error('Search failed ' + r.status)
      const d = await r.json()
      if (!d.data?.length) throw new Error('No papers found. Try a different search term.')
      const p = d.data[0]
      return res.status(200).json({
        title: p.title,
        abstract: p.abstract || '',
        authors: (p.authors || []).map(a => a.name),
        published: p.year ? String(p.year) : '',
        venue: p.venue || '',
        sourceId: p.externalIds?.DOI || p.paperId,
      })
    }

    return res.status(400).json({ error: 'Unknown type: ' + type })
  } catch (e) {
    console.error('Lookup error:', e.message)
    return res.status(500).json({ error: e.message })
  }
}

ENDFILE_api_lookup_js

echo ""
echo "=== All files created ==="
echo "Files:"
find . -type f -not -path './.git/*' | wc -l
echo ""
for f in api/lookup.js api/_helpers.js api/summarize.js src/supabase.js src/components/AuthModal.jsx vercel.json package.json src/App.jsx; do
  [ -f "$f" ] && echo "  ✅ $f" || echo "  ❌ MISSING: $f"
done
echo ""
echo "Run: git add . && git commit -m 'Fix CORS: proxy all API calls' && git push"
