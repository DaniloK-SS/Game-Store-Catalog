"use client"

import SortSelect from "./SortSelect"

type Props = {
  platform: string
  setPlatform: (value: string) => void
  genre: string
  setGenre: (value: string) => void
  inStock: boolean
  setInStock: (value: boolean) => void
  sort: string
  setSort: (value: string) => void
}

export default function FilterPanel({
  platform,
  setPlatform,
  genre,
  setGenre,
  inStock,
  setInStock,
  sort,
  setSort,
}: Props) {
  const isFiltered = platform || genre || inStock || sort

  return (
    <div className="bg-white border border-gray-100 rounded-2xl p-6 shadow-sm space-y-6">

      <h2 className="text-xl font-bold text-indigo-600 border-b pb-3">
        Filters Panel
      </h2>

      <SortSelect sort={sort} setSort={setSort} />

      <div>
        <p className="text-sm font-bold text-gray-800 mb-2">Platform</p>
        <div className="relative">
          <select
            value={platform}
            onChange={(e) => setPlatform(e.target.value)}
            className="w-full px-4 py-3 rounded-xl border-2 border-indigo-200 bg-indigo-50 text-indigo-600 font-medium focus:outline-none focus:ring-2 focus:ring-indigo-400 appearance-none cursor-pointer"
          >
            <option value="">All</option>
            <option value="PC">PC</option>
            <option value="PlayStation">PlayStation</option>
            <option value="Xbox">Xbox</option>
          </select>
          <div className="pointer-events-none absolute inset-y-0 right-3 flex items-center text-indigo-500">
            ▼
          </div>
        </div>
      </div>

      <div>
        <p className="text-sm font-bold text-gray-800 mb-2">Genre</p>
        <div className="relative">
          <select
            value={genre}
            onChange={(e) => setGenre(e.target.value)}
            className="w-full px-4 py-3 rounded-xl border-2 border-indigo-200 bg-indigo-50 text-indigo-600 font-medium focus:outline-none focus:ring-2 focus:ring-indigo-400 appearance-none cursor-pointer"
          >
            <option value="">All</option>
            <option value="Action">Action</option>
            <option value="RPG">RPG</option>
            <option value="Adventure">Adventure</option>
          </select>
          <div className="pointer-events-none absolute inset-y-0 right-3 flex items-center text-indigo-500">
            ▼
          </div>
        </div>
      </div>

      <div>
        <p className="text-sm font-bold text-gray-800 mb-2">Stock</p>
        <label className="flex items-center justify-between cursor-pointer group">
          <span className="text-sm text-gray-700 group-hover:text-indigo-600 transition">
            In Stock Only
          </span>
          <div
            onClick={() => setInStock(!inStock)}
            className={`w-10 h-5 rounded-full transition-colors duration-200 flex items-center px-0.5 ${
              inStock ? "bg-indigo-600" : "bg-gray-200"
            }`}
          >
            <div className={`w-4 h-4 rounded-full bg-white shadow transition-transform duration-200 ${
              inStock ? "translate-x-5" : "translate-x-0"
            }`} />
          </div>
        </label>
      </div>

      <button
        onClick={() => {
          setPlatform("")
          setGenre("")
          setInStock(false)
          setSort("")
        }}
        disabled={!isFiltered}
        className="w-full py-2 rounded-lg bg-gray-100 text-gray-700 font-medium hover:bg-indigo-600 hover:text-white transition duration-200 disabled:opacity-30 disabled:cursor-not-allowed disabled:hover:bg-gray-100 disabled:hover:text-gray-700"
      >
        Clear Filters
      </button>

    </div>
  )
}