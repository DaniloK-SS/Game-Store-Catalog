"use client"
import { useRouter, useSearchParams } from "next/navigation"
export default function SearchBar() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const search = searchParams.get("search") || ""

  function handleChange(e: React.ChangeEvent<HTMLInputElement>) {
    const value = e.target.value
    router.push(`/games?search=${value}`)
  }
  return (
    <input
      type="text"
      placeholder="Search games..."
      value={search}
      onChange={handleChange}
      className="w-full max-w-xs md:max-w-md mx-4 border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-500"/>
  )
}