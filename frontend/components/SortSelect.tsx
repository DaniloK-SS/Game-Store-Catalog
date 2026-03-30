"use client"

type Props = {
  sort: string
  setSort: (value: string) => void
}

export default function SortSelect({ sort, setSort }: Props) {
  return (
    <div>
      <p className="text-sm font-bold text-gray-800 mb-2">Sort By</p>
      <div className="relative">
        <select
          value={sort}
          onChange={(e) => setSort(e.target.value)}
          className="w-full px-4 py-3 rounded-xl border-2 border-indigo-200 bg-indigo-50 text-indigo-600 font-medium focus:outline-none focus:ring-2 focus:ring-indigo-400 appearance-none cursor-pointer"
        >
          <option value="">Default</option>
          <option value="priceLow">Price: Low → High</option>
          <option value="priceHigh">Price: High → Low</option>
          <option value="newest">Newest First</option>
          <option value="title">Title A → Z</option>
        </select>
        <div className="pointer-events-none absolute inset-y-0 right-3 flex items-center text-indigo-500">
          ▼
        </div>
      </div>
    </div>
  )
}