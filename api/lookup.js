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

