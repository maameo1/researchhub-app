import { useState } from 'react'
import { supabase, signUp, signIn, FREE_LIMITS } from '../supabase'

export default function AuthModal({ show, onClose, user, usage, onAuthChange }) {
  const [mode, setMode] = useState('login') // login | signup
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
        setMsg('Account created! You can now use ResearchHub.')
        // Auto sign in after signup
        await signIn(email, password)
      } else {
        await signIn(email, password)
      }
      onAuthChange()
      setTimeout(() => onClose(), 500)
    } catch (err) {
      setError(err.message || 'Authentication failed')
    }
    finally { setLoading(false) }
  }

  async function handleSignOut() {
    // Don't await supabase — it can hang. Just clear storage and reload.
    supabase.auth.signOut({ scope: 'local' }).catch(() => {})
    try {
      Object.keys(localStorage).forEach(k => {
        if (k.includes('supabase') || k.includes('sb-') || k.includes('auth-token')) {
          localStorage.removeItem(k)
        }
      })
    } catch {}
    window.location.reload()
  }

  // If user is logged in, show account info
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

          {/* Tier badge */}
          <div style={{ display: 'inline-block', padding: '4px 12px', borderRadius: 4, fontSize: 12, fontFamily: 'var(--mono)', background: isPro ? '#1a2e1a' : '#1a1a2e', color: isPro ? 'var(--accent-green-light)' : 'var(--accent-blue)', border: '1px solid ' + (isPro ? '#2a4a2a' : '#2a2a4a'), marginBottom: 20 }}>
            {isPro ? '★ PRO' : 'FREE TIER'}
          </div>

          {/* Usage stats */}
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

          {/* Upgrade button for free users */}
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

  // Login/Signup form
  return (
    <div style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.7)', zIndex: 100, display: 'flex', alignItems: 'center', justifyContent: 'center' }} onClick={e => { if (e.target === e.currentTarget) onClose() }}>
      <div style={{ background: 'var(--bg-secondary)', border: '1px solid var(--border)', borderRadius: 12, padding: 32, width: 420, maxWidth: '90vw' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 8 }}>
          <h3 style={{ fontSize: 22, color: 'var(--text-primary)', fontWeight: 400, margin: 0, fontFamily: 'var(--sans)' }}>
            Research<span style={{ color: 'var(--accent-green)', fontStyle: 'italic' }}>Hub</span>
          </h3>
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
            Free tier: {FREE_LIMITS.summaries} AI summaries · {FREE_LIMITS.gaps} gap analyses · {FREE_LIMITS.schematics} schematics<br />
            Upgrade to Pro for unlimited — $8/month
          </div>
        )}
      </div>
    </div>
  )
}
