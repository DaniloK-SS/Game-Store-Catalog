const API_BASE = 'https://game-store-catalog.onrender.com'

export async function apiFetch(path: string, options: RequestInit = {}) {
  const token = localStorage.getItem('token')

  const headers = new Headers(options.headers || {})
  headers.set('Content-Type', 'application/json')

  if (token) {
    headers.set('Authorization', `Bearer ${token}`)
  }

  const response = await fetch(`${API_BASE}${path}`, {
    ...options,
    headers,
  })

  if (response.status === 401) {
    localStorage.removeItem('token')
    window.location.href = '/admin/login'
  }

  return response
}