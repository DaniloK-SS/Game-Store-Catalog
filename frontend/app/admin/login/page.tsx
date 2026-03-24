'use client'
// log in za admina provjera (unesi password/salji na back/tacan pass ulaz na admin panel)
import { useState } from 'react'
import { useRouter } from 'next/navigation'

export default function AdminLoginPage() {
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const router = useRouter()

  const handleLogin = async () => { //dugme 
    setLoading(true)
    setError('')

    try {
      const res = await fetch('/api/admin/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ password }),
      })

      const data = await res.json()

      if (data.success) {
        localStorage.setItem('isAdmin', 'true')
        router.replace('/admin/games')
      } else {
        setError(data.message || 'Pogrešna lozinka')
      }
    } catch {
      setError('Greška na serveru')
    }

    setLoading(false)
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-linear-to-br from-gray-100 to-gray-200 px-4">
      <div className="w-full max-w-md bg-white rounded-2xl shadow-xl p-8 
                      animate-fade-in-up transition-all duration-500">
        <h1 className="text-2xl font-bold text-gray-800 mb-6 text-center">
          Admin Login
        </h1>
        <div className="mb-4">
          <label className="block text-sm text-gray-600 mb-1">
            Password
          </label>

          <input
            type="password"
            placeholder="Enter password..."
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleLogin()}
            className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm 
                       focus:outline-none focus:ring-2 focus:ring-blue-500 
                       transition duration-200"
          />
        </div>
        {error && (
          <p className="text-red-500 text-sm mb-3 animate-shake">
            {error}
          </p>
        )}
        <button
          onClick={handleLogin}
          disabled={loading}
          className="w-full bg-blue-600 text-white py-2 rounded-lg text-sm font-medium
                     hover:bg-blue-700 active:scale-[0.98]
                     transition duration-200 disabled:opacity-50"
        >
          {loading ? 'Logging in...' : 'Login'}
        </button>
      </div>
    </div>
  )
}