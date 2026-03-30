'use client'

import { useEffect, useState } from 'react'
import { useRouter, useParams } from 'next/navigation'
import { apiFetch } from '@/lib/apiFetch'

export default function EditGamePage() {
  const [form, setForm] = useState({
    title: '',
    genre: '',
    price: '',
    description: '',
    platform: '',
    publisher: '',
    releaseYear: '',
    coverImage: '',
    inStock: true,
    featured: false,
  })
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState('')
  const [uploading, setUploading] = useState(false)
  const router = useRouter()
  const params = useParams()
  const id = params.id

  useEffect(() => {
    // GET je PUBLIC — bez tokena
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
          releaseYear: game.release_year || game.releaseYear || '',
          coverImage: game.cover_image || game.coverImage || '',
          inStock: game.in_stock === true || game.inStock === true,
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

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file) return

    setUploading(true)
    setError('')

    const formData = new FormData()
    formData.append('file', file)
    formData.append('upload_preset', 'Game-Store')

    try {
      const res = await fetch(
        'https://api.cloudinary.com/v1_1/dnq35ub8e/image/upload',
        { method: 'POST', body: formData }
      )
      const data = await res.json()
      if (!res.ok) throw new Error()
      setForm(prev => ({ ...prev, coverImage: data.secure_url }))
    } catch {
      setError('Image upload failed')
    } finally {
      setUploading(false)
    }
  }

  const handleSubmit = async () => {
    setSaving(true)
    setError('')

    // PUT je PROTECTED — koristi apiFetch
    const res = await apiFetch(`/api/games/${id}`, {
      method: 'PUT',
      body: JSON.stringify({
        game: {
          title: form.title,
          genre: form.genre,
          platform: form.platform,
          price: form.price,
          release_year: Number(form.releaseYear),
          publisher: form.publisher,
          cover_image: form.coverImage,
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
    <div className="max-w-2xl mx-auto px-4 py-4 sm:p-6">
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-xl sm:text-2xl font-bold">Edit Game</h1>
        <button
          onClick={() => router.push('/admin/games')}
          className="text-gray-500 hover:text-gray-700 text-sm"
        >
          ← Back
        </button>
      </div>

      <div className="bg-white rounded-2xl shadow-md p-4 sm:p-6 flex flex-col gap-4 sm:gap-5">

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Title</label>
          <input name="title" value={form.title} onChange={handleChange}
            className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50 focus:ring-2 focus:ring-blue-500 focus:outline-none" />
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Genre</label>
            <select name="genre" value={form.genre} onChange={handleChange}
              className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50 focus:ring-2 focus:ring-blue-500 focus:outline-none">
              <option value="">Select genre</option>
              <option>Action</option><option>Adventure</option><option>RPG</option>
              <option>Racing</option><option>Shooter</option><option>Horror</option>
              <option>Puzzle</option><option>Survival</option>
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Platform</label>
            <select name="platform" value={form.platform} onChange={handleChange}
              className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50 focus:ring-2 focus:ring-blue-500 focus:outline-none">
              <option value="">Select platform</option>
              <option>PC</option><option>PlayStation</option><option>Xbox</option>
            </select>
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Price</label>
            <input name="price" value={form.price} onChange={handleChange}
              className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50 focus:ring-2 focus:ring-blue-500 focus:outline-none" />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Release Year</label>
            <input name="releaseYear" value={form.releaseYear} onChange={handleChange}
              className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50 focus:ring-2 focus:ring-blue-500 focus:outline-none" />
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Publisher</label>
          <input name="publisher" value={form.publisher} onChange={handleChange}
            className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50 focus:ring-2 focus:ring-blue-500 focus:outline-none" />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">Cover Image</label>

          {form.coverImage && (
            <div className="mb-3">
              <p className="text-xs text-gray-400 mb-1">Current image</p>
              <img
                src={form.coverImage}
                className="w-20 h-20 sm:w-24 sm:h-24 object-cover rounded-xl shadow"
              />
            </div>
          )}

          <div className="flex flex-col gap-2">
            <div>
              <p className="text-xs text-gray-400 mb-1">Upload a new file</p>
              <input
                type="file"
                accept="image/*"
                onChange={handleImageUpload}
                className="w-full text-sm file:mr-3 file:py-2 file:px-4 file:rounded-xl file:border-0 file:bg-blue-100 file:text-blue-700 hover:file:bg-blue-200"
              />
              {uploading && <p className="text-xs text-gray-400 mt-1 animate-pulse">Uploading...</p>}
            </div>

            <div>
              <p className="text-xs text-gray-400 mb-1">Or paste a new image URL</p>
              <input
                name="coverImage"
                value={form.coverImage}
                onChange={handleChange}
                placeholder="https://..."
                className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50 focus:ring-2 focus:ring-blue-500 focus:outline-none"
              />
            </div>
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Description</label>
          <textarea name="description" value={form.description} onChange={handleChange} rows={4}
            className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50 focus:ring-2 focus:ring-blue-500 focus:outline-none" />
        </div>

        <div className="flex gap-4 flex-wrap">
          <label className="flex items-center gap-2 text-sm text-gray-700">
            <input type="checkbox" name="inStock" checked={form.inStock} onChange={handleChange} />
            In Stock
          </label>
          <label className="flex items-center gap-2 text-sm text-gray-700">
            <input type="checkbox" name="featured" checked={form.featured} onChange={handleChange} />
            Featured
          </label>
        </div>

        {error && <p className="text-red-500 text-sm">{error}</p>}

        <button
          onClick={handleSubmit}
          disabled={saving || uploading}
          className="w-full py-3 bg-blue-600 text-white rounded-2xl text-sm font-semibold hover:bg-blue-700 disabled:opacity-50 transition">
          {saving ? 'Saving...' : 'Save Changes'}
        </button>

      </div>
    </div>
  )
}