export const config = { runtime: 'edge' }
import { callClaude, edgeHandler } from './_helpers.js'

export default edgeHandler('schematic', async (body) => {
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
