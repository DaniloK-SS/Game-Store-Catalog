'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'

export default function AdminLoginPage() {
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const router = useRouter()

  const handleLogin = async () => {
    setLoading(true)
    setError('')

    const res = await fetch('/api/admin/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ password })
    })

    const data = await res.json()

    if (data.success) {
      localStorage.setItem('isAdmin', 'true')
      router.replace('/admin/games')
    } else {
      setError(data.message || 'Pogrešna lozinka')
    }

    setLoading(false)
  }

  return (
    <div style={{ maxWidth: 400, margin: '100px auto', padding: 24 }}>
      <h1>Admin Login</h1>

      <input
        type="password"
        placeholder="Unesite lozinku"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        onKeyDown={(e) => e.key === 'Enter' && handleLogin()}
        style={{ width: '100%', padding: 8, marginBottom: 12 }}
      />

      {error && <p style={{ color: 'red' }}>{error}</p>}

      <button onClick={handleLogin} disabled={loading}>
        {loading ? 'Prijava...' : 'Prijavi se'}
      </button>
    </div>
  )
}
