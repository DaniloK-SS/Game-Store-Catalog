"use client"
type Props = {
  search: string
  setSearch: (value: string) => void
}
export default function SearchBar({ search, setSearch }: Props) {
  function handleChange(e: React.ChangeEvent<HTMLInputElement>) {
    setSearch(e.target.value)
  }
return (
    <input
      type="text"
      placeholder="Search games..."
      value={search}
      onChange={handleChange}
      className="w-full max-w-xs md:max-w-md mx-4 border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-500"
    />
)
}