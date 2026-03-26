'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'

export default function AdminLoginPage() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const router = useRouter()

  const handleLogin = async () => {
    setLoading(true)
    setError('')

    const res = await fetch('https://game-store-catalog.onrender.com/api/sessions', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password }),
    })

    const data = await res.json()

    if (res.ok) {
      localStorage.setItem('token', data.token)
      router.replace('/admin/games')
    } else {
      setError(data.message || 'Pogrešni podaci')
    }

    setLoading(false)
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-gray-100 to-gray-200 px-4">

      <div className="w-full max-w-md bg-white rounded-2xl shadow-xl p-8 transition duration-300 hover:shadow-2xl">

        <h1 className="text-2xl font-bold text-gray-800 mb-6 text-center">
          Admin Login
        </h1>

        <div className="mb-4">
          <label className="block text-sm text-gray-600 mb-1">Email</label>
          <input
            type="email"
            placeholder="admin@example.com"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm 
            focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 
            transition duration-200"
          />
        </div>

        <div className="mb-4">
          <label className="block text-sm text-gray-600 mb-1">Password</label>
          <input
            type="password"
            placeholder="Enter password..."
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleLogin()}
            className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm 
            focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 
            transition duration-200"
          />
        </div>

        {error && (
          <p className="text-red-500 text-sm mb-3 text-center animate-pulse">
            {error}
          </p>
        )}

        <button
          onClick={handleLogin}
          disabled={loading}
          className="w-full bg-indigo-600 text-white py-2 rounded-lg text-sm font-medium 
          hover:bg-indigo-700 active:scale-95 transition duration-200 
          disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {loading ? 'Logging in...' : 'Login'}
        </button>

      </div>

    </div>
  )
}