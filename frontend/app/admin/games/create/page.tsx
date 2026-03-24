'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'

export default function CreateGamePage() {
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

  const [loading, setLoading] = useState(false)
  const [uploading, setUploading] = useState(false)
  const [error, setError] = useState('')
  const router = useRouter()

  const isFormValid =
    form.title &&
    form.genre &&
    form.price &&
    form.description &&
    form.platform &&
    form.publisher &&
    form.releaseYear &&
    form.coverImage

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement> // input text,select,checbox
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

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => { //uzima fajl
    const file = e.target.files?.[0]
    if (!file) return

    setUploading(true)
    setError('')

    const formData = new FormData() //dio za upload
    formData.append('file', file)
    formData.append('upload_preset', 'Game-Store')

    try {
      const res = await fetch(
        'https://api.cloudinary.com/v1_1/dnq35ub8e/image/upload', //salje na cloudinary
        {
          method: 'POST',
          body: formData,
        }
      )

      const data = await res.json()

      if (!res.ok) throw new Error()

      setForm(prev => ({ //priprema Vracenog Url-a za state
        ...prev,
        coverImage: data.secure_url,
      }))
    } catch {
      setError('Image upload failed')
    } finally {
      setUploading(false)
    }
  }

  const handleSubmit = async () => { //salje gotove forme
    if (!isFormValid) {
      setError('Please fill all fields and upload image')
      return
    }

    setLoading(true)
    setError('')

    try {
      const res = await fetch(
        'https://game-store-catalog.onrender.com/api/games',
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
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
        }
      )
 
      if (res.ok) { //uspjesan odg
        router.push('/admin/games')
      } else {
        const data = await res.json()
        setError(JSON.stringify(data))
      }
    } catch {
      setError('Network error')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="max-w-2xl mx-auto p-6">
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Add New Game</h1>
        <button
          onClick={() => router.push('/admin/games')}
          className="text-gray-500 hover:text-gray-700 text-sm"
        >
          ← Back to Admin
        </button>
      </div>

      <div className="bg-white rounded-2xl shadow-lg p-8 flex flex-col gap-6">

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">Title</label>
          <input
            name="title"
            value={form.title}
            onChange={handleChange}
            placeholder="Game title"
            className="w-full border border-gray-300 rounded-xl px-4 py-2 text-sm focus:ring-2 focus:ring-blue-500 outline-none"
          />
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Genre</label>
            <select
              name="genre"
              value={form.genre}
              onChange={handleChange}
              className="w-full border border-gray-300 rounded-xl px-4 py-2 text-sm focus:ring-2 focus:ring-blue-500"
            >
              <option value="">Select genre</option>
              <option>Action</option>
              <option>Adventure</option>
              <option>RPG</option>
              <option>Racing</option>
              <option>Shooter</option>
              <option>Horror</option>
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Platform</label>
            <select
              name="platform"
              value={form.platform}
              onChange={handleChange}
              className="w-full border border-gray-300 rounded-xl px-4 py-2 text-sm focus:ring-2 focus:ring-blue-500"
            >
              <option value="">Select platform</option>
              <option>PC</option>
              <option>PlayStation</option>
              <option>Xbox</option>
            </select>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Price</label>
            <input
              name="price"
              value={form.price}
              onChange={handleChange}
              placeholder="29.99"
              className="w-full border border-gray-300 rounded-xl px-4 py-2 text-sm focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Release Year</label>
            <input
              name="releaseYear"
              value={form.releaseYear}
              onChange={handleChange}
              placeholder="2024"
              className="w-full border border-gray-300 rounded-xl px-4 py-2 text-sm focus:ring-2 focus:ring-blue-500"
            />
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">Publisher</label>
          <input
            name="publisher"
            value={form.publisher}
            onChange={handleChange}
            placeholder="Publisher name"
            className="w-full border border-gray-300 rounded-xl px-4 py-2 text-sm focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">Cover Image</label>

          <input
            type="file"
            accept="image/*"
            onChange={handleImageUpload}
            className="w-full border border-dashed border-gray-300 rounded-xl px-4 py-3 text-sm cursor-pointer hover:bg-gray-50"
          />

          {uploading && (
            <p className="text-sm text-gray-500 mt-2 animate-pulse">Uploading...</p>
          )}

          {form.coverImage && (
            <img
              src={form.coverImage}
              className="mt-3 w-24 h-24 object-cover rounded-xl shadow"
            />
          )}
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">Description</label>
          <textarea
            name="description"
            value={form.description}
            onChange={handleChange}
            rows={4}
            placeholder="Game description..."
            className="w-full border border-gray-300 rounded-xl px-4 py-2 text-sm focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div className="flex gap-6">
          <label className="flex items-center gap-2 text-sm text-gray-700">
            <input
              type="checkbox"
              name="inStock"
              checked={form.inStock}
              onChange={handleChange}
            />
            In Stock
          </label>

          <label className="flex items-center gap-2 text-sm text-gray-700">
            <input
              type="checkbox"
              name="featured"
              checked={form.featured}
              onChange={handleChange}
            />
            Featured
          </label>
        </div>

        {error && <p className="text-red-500 text-sm">{error}</p>}

        <button
          onClick={handleSubmit}
          disabled={loading || uploading || !isFormValid}
          className="mt-2 bg-blue-600 hover:bg-blue-700 transition text-white py-3 rounded-xl text-sm font-medium disabled:opacity-50"
        >
          {loading ? 'Creating...' : 'Add Game'}
        </button>
      </div>
    </div>
  )
}