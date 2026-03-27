'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { apiFetch } from '@/lib/apiFetch'

interface Game {
  id: number
  title: string
  genre: string
  price: string
  platform: string
  inStock: boolean
  coverImage: string
}

export default function AdminGamesPage() {
  const [games, setGames] = useState<Game[]>([])
  const [loading, setLoading] = useState(true)
  const router = useRouter()

  useEffect(() => {
    // GET ostaje PUBLIC — bez tokena
    fetch('https://game-store-catalog.onrender.com/api/games')
      .then(res => res.json())
      .then(data => {
        const raw = Array.isArray(data)
          ? data
          : Array.isArray(data.data)
          ? data.data
          : data.games || []

        const mapped = raw.map((g: any) => ({
          id: g.id,
          title: g.title,
          genre: g.genre,
          price: g.price,
          platform: g.platform,
          inStock: g.in_stock === true || g.inStock === true,
          coverImage: g.cover_image || g.coverImage || '',
        }))

        setGames(mapped)
        setLoading(false)
      })
  }, [])

  const handleDelete = async (id: number) => {
    if (!confirm('Are you sure you want to delete this game?')) return

    // DELETE je PROTECTED — koristi apiFetch sa tokenom
    await apiFetch(`/api/games/${id}`, { method: 'DELETE' })
    setGames(games.filter(g => g.id !== id))
  }

  const handleLogout = async () => {
    // Logout na backend
    await apiFetch('/api/sessions', { method: 'DELETE' })
    localStorage.removeItem('token')
    router.replace('/admin/login')
  }

  if (loading) return <p className="p-6">Loading...</p>

  return (
    <div className="max-w-6xl mx-auto p-4 md:p-6">

      <div className="flex flex-col gap-4 sm:flex-row sm:justify-between sm:items-center mb-6">
        <div>
          <h1 className="text-2xl font-bold">Admin Panel</h1>
          <p className="text-gray-500 text-sm">Manage your game catalog</p>
        </div>
        <div className="flex flex-wrap gap-2">
          <button
            onClick={() => router.push('/games')}
            className="px-4 py-2 border border-gray-300 rounded-lg text-sm hover:bg-gray-50">
            View Public Site
          </button>
          <button
            onClick={() => router.push('/admin/games/create')}
            className="px-4 py-2 bg-blue-600 text-white rounded-lg text-sm hover:bg-blue-700">
            + Add New Game
          </button>
          <button
            onClick={handleLogout}
            className="px-4 py-2 border border-gray-300 rounded-lg text-sm hover:bg-gray-50">
            Logout
          </button>
        </div>
      </div>

      <div className="bg-white rounded-xl shadow overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-50 border-b border-gray-200">
            <tr>
              <th className="text-left px-3 py-3 text-sm font-semibold text-gray-600">Game</th>
              {/* sakriveno na mobilnom, vidljivo od md */}
              <th className="hidden md:table-cell text-left px-3 py-3 text-sm font-semibold text-gray-600">Genre</th>
              <th className="hidden sm:table-cell text-left px-3 py-3 text-sm font-semibold text-gray-600">Platform</th>
              {/* price sakriveno na mobilnom */}
              <th className="hidden sm:table-cell text-left px-3 py-3 text-sm font-semibold text-gray-600">Price</th>
              {/* sakriveno na mobilnom, vidljivo od md */}
              <th className="hidden md:table-cell text-left px-3 py-3 text-sm font-semibold text-gray-600">Stock</th>
              <th className="text-left px-3 py-3 text-sm font-semibold text-gray-600">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {games.map(game => (
              <tr key={game.id} className="hover:bg-gray-50 transition-colors">

                <td className="px-3 py-3">
                  <div className="flex items-center gap-2">
                    {game.coverImage ? (
                      <img
                        src={game.coverImage}
                        alt={game.title}
                        className="w-9 h-9 md:w-11 md:h-11 object-cover rounded-lg shrink-0" />
                    ) : (
                      // ako ne prodje load slika //shrink-0 smanjuje se u odnosu na ostale elemente
                      <div className="w-9 h-9 md:w-11 md:h-11 bg-gray-200 rounded-lg flex items-center justify-center text-gray-400 text-xs shrink-0"> 
                        🎮
                      </div>
                    )}
                    <span className="font-medium text-gray-900 text-sm leading-tight">{game.title}</span>
                  </div>
                </td>

                {/* genre — sakriveno na mobilnom */}
                <td className="hidden md:table-cell px-3 py-3 text-gray-500 text-sm">{game.genre}</td>

                {/* platform — sakriveno na mobilnom */}
                <td className="hidden sm:table-cell px-3 py-3 text-gray-500 text-sm">{game.platform}</td>

                {/* price — sakriveno na mobilnom */}
                <td className="hidden sm:table-cell px-3 py-3 font-medium text-sm">${game.price}</td>

                {/* stock badge — sakriven na mobilnom */}
                <td className="hidden md:table-cell px-3 py-3">
                  <span className={`px-3 py-1 rounded-full text-xs font-semibold ${
                    game.inStock
                      ? 'bg-green-100 text-green-700'
                      : 'bg-red-100 text-red-700'
                  }`}>
                    {game.inStock ? 'In Stock' : 'Out of Stock'}
                  </span>
                </td>

                {/* edit stranice (button edit i delete) */}
                <td className="px-3 py-3">
                  <div className="flex items-center gap-1.5">
                    <button
                      onClick={() => router.push(`/admin/games/${game.id}/edit`)}
                      className="px-2.5 py-1.5 bg-blue-50 text-blue-600 hover:bg-blue-100 rounded-lg font-medium text-xs transition whitespace-nowrap">
                      Edit
                    </button>
                    <button
                      onClick={() => handleDelete(game.id)}
                      className="px-2.5 py-1.5 bg-red-50 text-red-500 hover:bg-red-100 rounded-lg font-medium text-xs transition whitespace-nowrap">
                      Delete
                    </button>
                  </div>
                </td>

              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}