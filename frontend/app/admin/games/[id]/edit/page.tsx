'use client'
import { useEffect, useState } from 'react'
import { useRouter, useParams } from 'next/navigation'

export default function EditGamePage() {
  const [form, setForm] = useState({
    title: '',
    genre: '',
    price: '',
    description: '',
    platform: '',
    publisher: '',
    releaseYear: '',
    inStock: true,
    featured: false,
  })
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState('')
  const router = useRouter()
  const params = useParams()
  const id = params.id

  useEffect(() => {
    fetch(`https://game-store-catalog.onrender.com/api/games/${id}`)
      .then(res => res.json())
      .then(data => {
        const game = data.game || data.data || data
        setForm({
          title: game.title || '',
          genre: game.genre || '',
          price: game.price || '',
          description: game.description || '',
          platform: game.platform || '',
          publisher: game.publisher || '',
          releaseYear: game.release_year || '',
          inStock: game.in_stock === true,
          featured: game.featured === true,
        })
        setLoading(false)
      })
  }, [id])
  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>
  ) => {
    const { name, value, type } = e.target

    setForm({
      ...form,
      [name]:
        type === 'checkbox'
          ? (e.target as HTMLInputElement).checked
          : value,
    })
  }
  const handleSubmit = async () => {
    setSaving(true)
    setError('')

    const res = await fetch(`https://game-store-catalog.onrender.com/api/games/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        game: {
          title: form.title,
          genre: form.genre,
          platform: form.platform,
          price: form.price,
          release_year: Number(form.releaseYear),
          publisher: form.publisher,
          description: form.description,
          in_stock: form.inStock,
          featured: form.featured,
        },
      }),
    })

    if (res.ok) {
      router.push('/admin/games')
    } else {
      setError('Error saving game')
    }
    setSaving(false)
  }

  if (loading) return <p className="p-6">Loading...</p>

  return (
    <div className="max-w-2xl mx-auto p-6">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">Edit Game</h1>
        <button
          onClick={() => router.push('/admin/games')}
          className="text-gray-500 hover:text-gray-700 text-sm">
          ← Back to Admin
        </button>
      </div>

      <div className="bg-white rounded-xl shadow p-6 flex flex-col gap-4">
        <div>
          <label className="block text-sm font-medium mb-1">Title</label>
          <input
            name="title"
            value={form.title}
            onChange={handleChange}
            className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500"/>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1">Genre</label>
            <select
              name="genre"
              value={form.genre}
              onChange={handleChange}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500">
              <option value="">Select genre</option>
              <option value="Action">Action</option>
              <option value="Adventure">Adventure</option>
              <option value="RPG">RPG</option>
              <option value="Racing">Racing</option>
              <option value="Shooter">Shooter</option>
              <option value="Horror">Horror</option>
              <option value="Puzzle">Puzzle</option>
              <option value="Survival">Survival</option>
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">Platform</label>
            <select
              name="platform"
              value={form.platform}
              onChange={handleChange}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500">
              <option value="">Select platform</option>
              <option value="PC">PC</option>
              <option value="PlayStation">PlayStation</option>
              <option value="Xbox">Xbox</option>
            </select>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1">Price</label>
            <input
              name="price"
              value={form.price}
              onChange={handleChange}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500"/>
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">Release Year</label>
            <input
              name="releaseYear"
              value={form.releaseYear}
              onChange={handleChange}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500"/>
          </div>
        </div>
        <div>
          <label className="block text-sm font-medium mb-1">Publisher</label>
          <input
            name="publisher"
            value={form.publisher}
            onChange={handleChange}
            className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div>
          <label className="block text-sm font-medium mb-1">Description</label>
          <textarea
            name="description"
            value={form.description}
            onChange={handleChange}
            rows={4}
            className="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500"/>
        </div>
        <div className="flex gap-6">
          <label className="flex items-center gap-2 text-sm">
            <input
              type="checkbox"
              name="inStock"
              checked={form.inStock}
              onChange={handleChange}/>
            In Stock
          </label>
          <label className="flex items-center gap-2 text-sm">
            <input
              type="checkbox"
              name="featured"
              checked={form.featured}
              onChange={handleChange}/>
            Featured
          </label>
        </div>

        {error && <p className="text-red-500 text-sm">{error}</p>}

        <div className="flex gap-3 pt-2">
          <button
            onClick={handleSubmit}
            disabled={saving}
            className="px-6 py-2 bg-blue-600 text-white rounded-lg text-sm hover:bg-blue-700 disabled:opacity-50">
            {saving ? 'Saving...' : 'Save Changes'}
          </button>
          <button
            onClick={() => router.push('/admin/games')}
            className="px-6 py-2 border border-gray-300 rounded-lg text-sm hover:bg-gray-50">
            Cancel
          </button>
        </div>
      </div>
    </div>
  )
}