"use client"
import Link from "next/link"
import { useState } from "react"
import { FaGamepad } from "react-icons/fa"
import { MdPlaylistAddCheck } from "react-icons/md"
import { CiMenuBurger } from "react-icons/ci"
import SearchBar from "./SearchBar"

export default function Navbar() {
  const [open, setOpen] = useState(false)

  return (
    <nav className="w-full border-b bg-white shadow-sm sticky top-0 z-50">
      <div className="max-w-6xl mx-auto px-4 py-3 flex items-center justify-between gap-3">
        <Link href="/" className="flex items-center gap-2 text-lg font-bold text-gray-800 shrink-0">
          <FaGamepad className="text-indigo-600 text-xl" />
          <span className="hidden sm:inline">GameStore</span>
        </Link>
        <div className="flex-1 max-w-50 sm:max-w-xs md:max-w-md">
          <SearchBar />
        </div>
        <div className="hidden md:flex items-center gap-6 text-gray-700 font-medium shrink-0">
          <Link href="/" className="hover:text-indigo-600 transition">Home</Link>
          <Link href="/games" className="hover:text-indigo-600 transition">Games</Link>
          <Link href="/wishlist" className="hover:text-indigo-600 transition">
            <MdPlaylistAddCheck className="text-xl" />
          </Link>
        </div>
        <button
          onClick={() => setOpen(!open)}
          className="md:hidden text-2xl text-gray-700 shrink-0"
        >
          <CiMenuBurger />
        </button>
        {open && (
          <div className="absolute right-4 top-16 w-44 bg-white border rounded-xl shadow-xl p-4 flex flex-col gap-4 text-gray-700 z-50">
            <Link href="/" onClick={() => setOpen(false)}>Home</Link>
            <Link href="/games" onClick={() => setOpen(false)}>Games</Link>
            <Link href="/wishlist" onClick={() => setOpen(false)}>Wishlist</Link>
          </div>
        )}

      </div>
    </nav>
  )
}