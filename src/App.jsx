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
  const [apiKey, setApiKey] = useState(() => localStorage.getItem(AK) || '')
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
  const [authLoading, setAuthLoading] = useState(true)

  // Check auth on load
  useEffect(() => {
    async function checkAuth() {
      try {
        const u = await getUser()
        setUser(u)
        if (u) { const us = await getUsage(); setUsage(us) }
      } catch {}
      setAuthLoading(false)
    }
    checkAuth()
    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, session) => {
      const u = session?.user || null
      setUser(u)
      if (u) { const us = await getUsage(); setUsage(us) }
      else setUsage(null)
    })
    return () => subscription.unsubscribe()
  }, [])

  // Refresh usage after AI calls
  async function refreshUsage() {
    try { const us = await getUsage(); setUsage(us) } catch {}
  }

  // Debounced save — prevents lag during batch summarization
  const saveTimer = useRef(null)
  useEffect(() => {
    if (saveTimer.current) clearTimeout(saveTimer.current)
    saveTimer.current = setTimeout(() => {
      try { sv(PK, papers) }
      catch (e) { console.warn('Storage save failed:', e) }
    }, 500)
    return () => { if (saveTimer.current) clearTimeout(saveTimer.current) }
  }, [papers])
  useEffect(() => { if (gap) sv(GK, gap) }, [gap])

  // ── Add Paper ──────────────────────────────────────────────────────────
  async function addPaper() {
    if (!input.trim() && !pdf) return
    setLoading(true); setError(null)
    try {
      let md = {}
      if (pdf) {
        if (!apiKey) setLoadingMsg('Reading PDF via server...')
        else setLoadingMsg('Reading PDF...')
        const b64 = await new Promise((res, rej) => { const r = new FileReader(); r.onload = () => res(r.result.split(',')[1]); r.onerror = () => rej(new Error('Fail')); r.readAsDataURL(pdf) })
        setLoadingMsg('Extracting...')
        md = await extractPdf(apiKey, b64)
        md.source = 'PDF'; md.sourceId = pdf.name
      } else {
        const t = input.trim()
        // Check DOI first (before arXiv, because DOIs can contain arXiv-like number patterns)
        const dm = t.match(/(10\.\d{4,}\/[^\s]+)/)
        // Only match arXiv if no DOI found, and input looks like a standalone arXiv ID or arxiv URL
        const am = !dm && t.match(/(?:arxiv\.org\/abs\/)?(\d{4}\.\d{4,5})(?:v\d+)?$/i)

        if (dm) {
          setLoadingMsg('DOI...')
          try {
            const controller = new AbortController()
            const timeout = setTimeout(() => controller.abort(), 15000)
            const r = await fetch('https://api.crossref.org/works/' + encodeURIComponent(dm[1]), { signal: controller.signal })
            clearTimeout(timeout)
            if (!r.ok) throw new Error('DOI not found in Crossref')
            const di = (await r.json()).message
            md = { title: (di.title || ['?'])[0], abstract: (di.abstract || '').replace(/<[^>]+>/g, ''), authors: (di.author || []).map(a => ((a.given || '') + ' ' + (a.family || '')).trim()), published: di.published?.['date-parts']?.[0]?.join('-') || '', venue: (di['container-title'] || [''])[0], source: 'DOI', sourceId: dm[1] }
          } catch (e) {
            const msg = e.name === 'AbortError' ? 'DOI lookup timed out. Crossref may be slow — try pasting the paper title instead.' : 'DOI lookup failed: ' + e.message + '. Try pasting the paper title instead.'
            throw new Error(msg)
          }
        } else if (am) {
          setLoadingMsg('arXiv...')
          try {
            const controller = new AbortController()
            const timeout = setTimeout(() => controller.abort(), 15000)
            const r = await fetch('https://export.arxiv.org/api/query?id_list=' + am[1], { signal: controller.signal })
            clearTimeout(timeout)
            if (!r.ok) throw new Error('arXiv API error')
            const x = new DOMParser().parseFromString(await r.text(), 'text/xml')
            const e = x.querySelector('entry')
            if (!e || !e.querySelector('title')) throw new Error('Paper not found on arXiv')
            md = { title: e.querySelector('title')?.textContent?.replace(/\s+/g, ' ').trim() || '', abstract: e.querySelector('summary')?.textContent?.trim() || '', authors: [...e.querySelectorAll('author name')].map(n => n.textContent), published: e.querySelector('published')?.textContent?.slice(0, 10) || '', source: 'arXiv', sourceId: am[1] }
          } catch (e) {
            throw new Error(e.name === 'AbortError' ? 'arXiv lookup timed out. Try again or paste the paper title.' : 'arXiv lookup failed: ' + e.message + '. Try pasting the paper title instead.')
          }
        } else {
          setLoadingMsg('Searching...')
          try {
            const controller = new AbortController()
            const timeout = setTimeout(() => controller.abort(), 15000)
            const r = await fetch('https://api.semanticscholar.org/graph/v1/paper/search?query=' + encodeURIComponent(t) + '&limit=1&fields=title,abstract,authors,year,externalIds,venue', { signal: controller.signal })
            clearTimeout(timeout)
            if (r.status === 429) throw new Error('Search rate limited. Wait a minute and try again.')
            if (!r.ok) throw new Error('Search failed')
            const d = await r.json()
            if (!d.data?.length) throw new Error('No papers found. Try a different search term.')
            const p = d.data[0]
            md = { title: p.title, abstract: p.abstract || '', authors: (p.authors || []).map(a => a.name), published: p.year ? String(p.year) : '', venue: p.venue || '', source: 'Search', sourceId: p.externalIds?.DOI || p.paperId }
          } catch (e) {
            throw new Error(e.name === 'AbortError' ? 'Search timed out. Try a shorter search term.' : e.message.includes('rate') ? e.message : 'Search failed: ' + e.message)
          }
        }
      }
      if (papers.some(p => p.title?.toLowerCase() === md.title?.toLowerCase())) { setError('Already in library.'); setLoading(false); return }
      let sum = null
      if (user) {
        try { sum = await genSummary(apiKey, md) } catch (e) { console.warn('Auto-summary failed:', e.message) }
      }
      const np = { id: gid(), ...md, summary: sum, addedAt: new Date().toISOString(), notes: '', readStatus: 'unread', figure: null, schematic: null }
      setPapers(prev => [np, ...prev]); setInput(''); setPdf(null); if (fRef.current) fRef.current.value = ''
      setSelected(np); setTab('detail')
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
          if (r.status === 403) throw new Error('Zotero 403 Forbidden - check your API key has read access')
          if (r.status === 404) throw new Error('Zotero 404 - check your User ID is correct')
          throw new Error('Zotero error ' + r.status)
        }
        const items = await r.json(); if (!items.length) break
        all = [...all, ...items]; setZotMsg('Found ' + all.length + ' items...')
        if (items.length < 50 || all.length > 500) break; start += 50
      }
      // Filter to paper types locally (more reliable than API filter)
      const types = new Set(['journalArticle', 'conferencePaper', 'preprint', 'book', 'bookSection', 'thesis', 'report', 'manuscript', 'document'])
      const zi = all.filter(i => types.has(i.data?.itemType))
      setZotMsg('Found ' + zi.length + ' papers out of ' + all.length + ' items. Checking duplicates...')
      
      const ex = new Set(papers.map(p => p.title?.toLowerCase().trim())); const nw = []
      let skipped = 0
      for (const item of zi) {
        const d = item.data
        if (!d.title) continue
        if (ex.has(d.title.toLowerCase().trim())) { skipped++; continue }
        ex.add(d.title.toLowerCase().trim())
        nw.push({ id: gid(), title: d.title, authors: (d.creators || []).filter(c => c.creatorType === 'author').map(c => ((c.firstName || '') + ' ' + (c.lastName || '')).trim()), abstract: d.abstractNote || '', published: d.date || '', venue: d.publicationTitle || d.proceedingsTitle || d.bookTitle || '', source: 'Zotero', sourceId: d.DOI || d.key, url: d.url || '', summary: null, addedAt: new Date().toISOString(), notes: '', readStatus: 'unread', figure: null, schematic: null, starred: false })
      }
      if (nw.length) setPapers(prev => [...nw, ...prev])
      setZotMsg('Imported ' + nw.length + ' new papers' + (skipped > 0 ? ' (' + skipped + ' duplicates skipped)' : '') + '. Total library: ' + (papers.length + nw.length))
      setTimeout(() => setZotMsg(''), 10000)
    } catch (err) { setError('Zotero failed: ' + err.message) }
    finally { setZotL(false) }
  }

  async function sumAll() {
    const un = papers.filter(p => !p.summary); if (!un.length) return
    if (!user && !apiKey) { setError('Please sign in to use AI summaries.'); setShowAuth(true); return }
    setSumL(true); setError(null); let upd = [...papers]
    for (let i = 0; i < un.length; i++) {
      setLoadingMsg('Summarizing ' + (i + 1) + '/' + un.length + ': ' + un[i].title.slice(0, 35) + '...')
      try {
        const s = await genSummary(apiKey, un[i])
        upd = upd.map(p => p.id === un[i].id ? { ...p, summary: s } : p)
      } catch (e) {
        if (e.message?.includes('limit reached')) { setError(e.message); break }
        // Fallback: create basic summary from abstract
        upd = upd.map(p => p.id === un[i].id ? { ...p, summary: { tldr: (p.abstract || '').slice(0, 100), tags: ['untagged'], key_contributions: [], methods: [], limitations: [], open_questions: [], key_citations_to_follow: [], relevance_to_medical_imaging: '' } } : p)
      }
    }
    setPapers(upd); setSumL(false); setLoadingMsg(''); refreshUsage()
  }

  async function runGap() {
    if (papers.length < 2) { setError('Need 2+ papers'); return }
    if (!user && !apiKey) { setError('Please sign in to use gap analysis.'); setShowAuth(true); return }
    setGapL(true); setError(null)
    try {
      const parsed = await genGap(apiKey, papers)
      setGap(parsed); setTab('gaps'); refreshUsage()
    } catch (err) {
      setError('Gap analysis failed: ' + (err.message || 'Unknown error'))
    }
    finally { setGapL(false) }
  }

  async function genWeekly() {
    if (papers.length < 3) { setError('Need 3+ papers for reading suggestions.'); return }
    if (!user && !apiKey) { setError('Please sign in for weekly reading suggestions.'); setShowAuth(true); return }
    setWeeklyL(true); setError(null)
    try {
      const parsed = await genWeeklyRecs(apiKey, papers)
      parsed.generatedAt = new Date().toISOString()
      setWeeklyRecs(parsed)
      sv('rh_weekly', parsed)
      refreshUsage()
    } catch (err) { setError('Weekly suggestions failed: ' + err.message) }
    finally { setWeeklyL(false) }
  }

  function del(id) { setPapers(p => p.filter(x => x.id !== id)); if (selected?.id === id) { setSelected(null); setTab('library') } }
  function togRead(id) { setPapers(p => p.map(x => x.id === id ? { ...x, readStatus: x.readStatus === 'read' ? 'unread' : 'read' } : x)) }
  function togStar(id) { setPapers(p => p.map(x => x.id === id ? { ...x, starred: !x.starred } : x)); if (selected?.id === id) setSelected(p => ({ ...p, starred: !p.starred })) }
  function updNotes(id, n) { setPapers(p => p.map(x => x.id === id ? { ...x, notes: n } : x)); if (selected?.id === id) setSelected(p => ({ ...p, notes: n })) }
  function updFigure(id, fig) {
    // Warn if figure is very large (base64 images can be huge)
    if (fig && fig.length > 2000000) {
      if (!confirm('This image is large and may exceed browser storage limits. Continue?')) return
    }
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

  // ── Shared header + nav ────────────────────────────────────────────────
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

  // ── Route views ────────────────────────────────────────────────────────
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
