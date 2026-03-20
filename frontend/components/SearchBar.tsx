"use client"

import { useState, useEffect } from "react"
import { useSearch } from "@/components/SearchContext"
import { FaSearch } from "react-icons/fa"

export default function SearchBar() {
  const { search, setSearch } = useSearch()
  const [input, setInput] = useState("")
  // 🔥 sync 
  useEffect(() => {
    setInput(search)
  }, [search])
  //  debounce (live search)
  useEffect(() => {
    const timeout = setTimeout(() => {
      setSearch(input)
    }, 300)

    return () => clearTimeout(timeout)
  }, [input, setSearch])

  const handleSubmit = () => {
    setSearch(input)
  }
  return (
    <div className="flex items-center w-full max-w-xs md:max-w-md mx-4 border rounded-lg overflow-hidden focus-within:ring-2 focus-within:ring-indigo-500">

      <input
        type="text"
        placeholder="Search games..."
        value={input}
        onChange={(e) => setInput(e.target.value)}
        className="w-full px-4 py-2 outline-none"
      />

      <button
        onClick={handleSubmit}
        className="px-4 text-gray-600 hover:text-indigo-600 transition"
      >
        <FaSearch />
      </button>

    </div>
  )
}