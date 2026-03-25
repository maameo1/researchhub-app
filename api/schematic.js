import { callClaude, handler } from './_helpers.js'

export default handler(async (body) => {
  const { title, abstract, methods, contributions } = body
  if (!title) throw new Error('Title required')

  const svg = await callClaude(`You are an expert scientific diagram designer. Create a CLEAN, PROFESSIONAL SVG pipeline/architecture diagram for this paper.

Title: ${title}
Abstract: ${abstract || 'N/A'}
Methods: ${methods || 'N/A'}
Key contributions: ${contributions || 'N/A'}

STRICT RULES - follow exactly:
1. Return ONLY raw SVG code. No markdown, no backticks, no explanation.
2. Start with <svg viewBox="0 0 700 350" xmlns="http://www.w3.org/2000/svg"> and end with </svg>
3. LAYOUT: Use a clear LEFT-TO-RIGHT flow with 3-6 main stages. Space boxes evenly.
4. BOXES: Use <rect> with rx="8" ry="8", width 100-130, height 50-65.
5. COLORS for boxes (use different ones for different stages):
   - Input/Data: fill="#1a3329" stroke="#5b8a72" (green)
   - Processing/Model: fill="#1a2535" stroke="#7eb8da" (blue)
   - Key Method: fill="#251a35" stroke="#9070c4" (purple)
   - Output/Result: fill="#2e2a1a" stroke="#d1c490" (gold)
   - Loss/Training: fill="#2e1a1a" stroke="#d19090" (red)
6. TEXT: Use fill="#e8e8e8" font-family="Arial,sans-serif".
   - Stage labels: font-size="12" font-weight="bold" centered in boxes
   - Sub-labels below: font-size="9" fill="#8a9bb5"
7. ARROWS: Use <line> or <path> with stroke="#4a5a6a" stroke-width="2" and marker-end with a proper arrowhead. Define arrowhead in <defs>.
8. Add a title at top: font-size="14" fill="#e8e8e8" font-weight="bold"
9. BACKGROUND: Add <rect width="700" height="350" fill="#0e1318" rx="8"/>
10. Make it look like a real conference paper figure - clean, professional, readable.
11. Vertically center the pipeline boxes around y=160.
12. Add thin connector labels on arrows if relevant (font-size="8" fill="#6a7b8f").`, 3000)

  return { schematic: svg.trim() }
})
