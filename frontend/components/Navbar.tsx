"use client"
import Link from "next/link"
import { useState } from "react"
import { FaGamepad } from "react-icons/fa"
import { MdPlaylistAddCheck } from "react-icons/md"
import { CiMenuBurger } from "react-icons/ci"
import SearchBar from "./SearchBar"
type Props = {
  search: string
  setSearch: (value: string) => void
}
export default function Navbar({ search, setSearch }: Props) {
  const [open, setOpen] = useState(false)
  return (
    <nav className="w-full border-b bg-white shadow-sm">
      <div className="max-w-6xl mx-auto flex items-center justify-between px-6 py-4 relative">
        <Link href="/" className="flex items-center gap-2 text-xl font-bold text-gray-800">
          <FaGamepad className="text-indigo-600 text-2xl" />
          <span className="hidden md:inline">GameStore</span>
        </Link>
        <SearchBar search={search} setSearch={setSearch} />
        <div className="hidden md:flex items-center gap-8 text-gray-700 font-medium">
          <Link href="/">Home</Link>
          <Link href="/games">Games</Link>
          <Link href="/wishlist">
          <MdPlaylistAddCheck className="text-xl" />
          </Link>
        </div>
        <button
          onClick={() => setOpen(!open)}
          className="md:hidden text-2xl text-gray-700">
        <CiMenuBurger />
        </button>
        {open && (
          <div className="absolute right-6 top-full mt-2 w-40 bg-white border rounded-lg shadow-md p-4 flex flex-col gap-4 text-gray-700">
            <Link href="/" onClick={() => setOpen(false)}>
              Home
            </Link>
            <Link href="/games" onClick={() => setOpen(false)}>
              Games
            </Link>
            <Link href="/wishlist" onClick={() => setOpen(false)}>
              Wishlist
            </Link>
          </div>
        )}
    </div>
    </nav>
  )
}