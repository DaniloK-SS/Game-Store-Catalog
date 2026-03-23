"use client"
type Props = {
  sort: string
  setSort: (value: string) => void //mjenja state,na vraca nista
}

export default function SortSelect({ sort, setSort }: Props) {
  return (
    <div>
      <p className="text-sm font-semibold text-gray-600">Sort By</p>

      <select
        value={sort}
        onChange={(e) => setSort(e.target.value)}
        className="w-full mt-2 px-3 py-2 rounded-lg border border-gray-300 bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500 transition hover:border-indigo-400"
      >
        <option value="">Default</option>
        <option value="priceLow">Price: Low → High</option>
        <option value="priceHigh">Price: High → Low</option>
        <option value="newest">Newest First</option>
        <option value="title">Title A → Z</option>
      </select>
    </div>
  )
}