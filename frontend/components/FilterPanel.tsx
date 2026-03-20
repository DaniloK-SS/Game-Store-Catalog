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
  return (
    <div className="bg-white/80 backdrop-blur-md border border-gray-200 rounded-2xl p-5 shadow-lg space-y-5 transition hover:shadow-xl">

      <h2 className="text-lg font-bold border-b pb-2 text-gray-800">
        Filters Panel
      </h2>

      <SortSelect sort={sort} setSort={setSort} />

      <div>
        <p className="text-sm font-semibold text-gray-600">Platform</p>
        <select
          value={platform}
          onChange={(e) => setPlatform(e.target.value)}
          className="w-full mt-2 px-3 py-2 rounded-lg border border-gray-300 bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500 transition hover:border-indigo-400"
        >
          <option value="">All</option>
          <option value="PC">PC</option>
          <option value="PlayStation">PlayStation</option>
          <option value="Xbox">Xbox</option>
        </select>
      </div>

      <div>
        <p className="text-sm font-semibold text-gray-600">Genre</p>
        <select
          value={genre}
          onChange={(e) => setGenre(e.target.value)}
          className="w-full mt-2 px-3 py-2 rounded-lg border border-gray-300 bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500 transition hover:border-indigo-400"
        >
          <option value="">All</option>
          <option value="Action">Action</option>
          <option value="RPG">RPG</option>
          <option value="Adventure">Adventure</option>
        </select>
      </div>

      <div>
        <p className="text-sm font-semibold text-gray-600">Stock</p>
        <label className="flex items-center gap-3 mt-2 cursor-pointer group">
          <input
            type="checkbox"
            checked={inStock}
            onChange={(e) => setInStock(e.target.checked)}
            className="w-4 h-4 accent-indigo-600 cursor-pointer"
          />
          <span className="text-sm text-gray-700 group-hover:text-indigo-600 transition">
            In Stock Only
          </span>
        </label>
      </div>

      <button
        onClick={() => {
          setPlatform("")
          setGenre("")
          setInStock(false)
          setSort("")
        }}
        className="w-full py-2 rounded-lg bg-gray-100 text-gray-700 font-medium hover:bg-indigo-600 hover:text-white transition duration-200"
      >
        Clear Filters
      </button>

    </div>
  )
}