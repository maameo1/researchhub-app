export const config = { runtime: 'edge' }

export default async function handler(req) {
  if (req.method === 'OPTIONS') {
    return new Response(null, { status: 200, headers: { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Methods': 'POST, OPTIONS', 'Access-Control-Allow-Headers': 'Content-Type' } })
  }
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), { status: 405, headers: { 'Content-Type': 'application/json' } })
  }

  const { type, query } = await req.json()
  if (!type || !query) {
    return new Response(JSON.stringify({ error: 'type and query required' }), { status: 400, headers: { 'Content-Type': 'application/json' } })
  }

  try {
    if (type === 'arxiv') {
      const r = await fetch('https://export.arxiv.org/api/query?id_list=' + encodeURIComponent(query), { signal: AbortSignal.timeout(25000) })
      if (!r.ok) throw new Error('arXiv error ' + r.status)
      const xml = await r.text()
      return new Response(JSON.stringify({ xml }), { status: 200, headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' } })
    }

    if (type === 'doi') {
      const r = await fetch('https://api.crossref.org/works/' + encodeURIComponent(query), { signal: AbortSignal.timeout(25000) })
      if (!r.ok) throw new Error('DOI not found in Crossref')
      const data = await r.json()
      const di = data.message
      return new Response(JSON.stringify({
        title: (di.title || ['?'])[0],
        abstract: (di.abstract || '').replace(/<[^>]+>/g, ''),
        authors: (di.author || []).map(a => ((a.given || '') + ' ' + (a.family || '')).trim()),
        published: di.published?.['date-parts']?.[0]?.join('-') || '',
        venue: (di['container-title'] || [''])[0],
      }), { status: 200, headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' } })
    }

    if (type === 'search') {
      const r = await fetch('https://api.semanticscholar.org/graph/v1/paper/search?query=' + encodeURIComponent(query) + '&limit=1&fields=title,abstract,authors,year,externalIds,venue', { signal: AbortSignal.timeout(25000) })
      if (r.status === 429) throw new Error('Search rate limited. Wait a minute and try again.')
      if (!r.ok) throw new Error('Search failed ' + r.status)
      const d = await r.json()
      if (!d.data?.length) throw new Error('No papers found. Try a different search term.')
      const p = d.data[0]
      return new Response(JSON.stringify({
        title: p.title,
        abstract: p.abstract || '',
        authors: (p.authors || []).map(a => a.name),
        published: p.year ? String(p.year) : '',
        venue: p.venue || '',
        sourceId: p.externalIds?.DOI || p.paperId,
      }), { status: 200, headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' } })
    }

    return new Response(JSON.stringify({ error: 'Unknown type' }), { status: 400, headers: { 'Content-Type': 'application/json' } })
  } catch (e) {
    const msg = e.name === 'TimeoutError' ? type + ' lookup timed out. The API may be slow — try again.' : e.message
    return new Response(JSON.stringify({ error: msg }), { status: 500, headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' } })
  }
}
