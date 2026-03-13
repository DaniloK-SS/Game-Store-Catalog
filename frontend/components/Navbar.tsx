"use client"
import Link from "next/link"
import { useState } from "react"
import { FaGamepad } from "react-icons/fa"
import { MdPlaylistAddCheck } from "react-icons/md"

export default function Navbar() {
  const [search, setSearch] = useState("")

  function handleChange(e: React.ChangeEvent<HTMLInputElement>) {
    const value = e.target.value
    setSearch(value)

  }
  return (
    <nav className="w-full border-b bg-white shadow-sm">
      <div className="max-w-6xl mx-auto flex items-center justify-between px-6 py-4">

        <Link
          href="/"
          className="flex items-center gap-2 text-xl font-bold text-gray-800 hover:text-indigo-600 transition duration-200"
        >
          <FaGamepad className="text-indigo-600 text-2xl" />
          GameStore
        </Link>
        <input
          type="text"
          placeholder="Search games..."
          value={search}
          onChange={handleChange}
          className="w-full max-w-md border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-200"
        />
        <div className="flex items-center gap-8 text-gray-700 font-medium">

          <Link
            href="/"
            className="hover:text-indigo-600 transition duration-200"
          >
            Home
          </Link>

          <Link
            href="/games"
            className="hover:text-indigo-600 transition duration-200"
          >
            Games
          </Link>

          <Link
            href="/wishlist"
            className="flex items-center gap-2 hover:text-indigo-600 transition duration-200"
          >
            <MdPlaylistAddCheck className="text-xl" />
            
          </Link>
        </div>
      </div>
    </nav>
  )
}