"use client"

import { useEffect, useState } from "react"
import GameGrid from "@/components/GameGrid"
import Show from "@/components/Show"
import { useSearch } from "@/components/SearchContext"
import EmptyState from "@/components/EmptyState"
import { getGames } from "@/lib/GetGames"

const getWishlist = () => {
  const stringList = localStorage.getItem("wishlist")
  return stringList?.split(",")
    .map(x => Number.parseInt(x.trim()))
    .filter(num => Number.isFinite(num) && !Number.isNaN(num)) ?? []
}

const isInWishlist = (wishlist: number[], gameId: number) => {
  return wishlist.some(wishlistId => wishlistId === gameId)
}

export default function HomePage() {
  const { search, setSearch } = useSearch()

  const [games, setGames] = useState<any[]>([])
  const [sort, setSort] = useState("new")
  const [wishlist, setWishlist] = useState<number[]>([])
  const [i, setI] = useState(0)

  // FETCH
  useEffect(() => {
    async function fetchData() {
      const data = await getGames()
      console.log("API RESPONSE:", data)
      const parsedGames = Array.isArray(data)
        ? data
        : data?.data || data?.games || []

      setGames(parsedGames) 
    }

    fetchData()
    setWishlist(getWishlist())
  }, [])

  const featured = games.filter(g => g.featured).slice(0, 5)

  const handleAddToWishlist = (gameId: number) => {
    if (wishlist.includes(gameId)) return

    const newWishlist = [...wishlist, gameId]
    setWishlist(newWishlist)
    localStorage.setItem("wishlist", newWishlist.join(","))
  }

  const handleRemoveFromWishlist = (gameId: number) => {
    const newWishlist = wishlist.filter(gid => gid !== gameId)
    setWishlist(newWishlist)
    localStorage.setItem("wishlist", newWishlist.join(","))
  }

  const filteredGames = games
    .filter(g =>
      g.title?.toLowerCase().includes(search.toLowerCase())
    )
    .sort((a, b) => {
      if (sort === "new") {
        return b.releaseYear - a.releaseYear
      } else {
        return a.releaseYear - b.releaseYear
      }
    })

  return (
    <div className="max-w-7xl mx-auto p-6">

      <h2 className="text-2xl font-bold mb-6">Featured Games</h2>

      <div className="relative h-90 rounded-2xl overflow-hidden group shadow-xl mb-6">
        <img
          src={featured[i]?.coverImage}
          className="w-full h-full object-cover transition duration-700 group-hover:scale-105"
        />

        <div className="absolute inset-0 bg-linear-to-t from-black/80 via-black/30 to-transparent" />

        <div className="absolute bottom-6 left-6 text-white">
          <h3 className="text-3xl font-bold mb-1">
            {featured[i]?.title}
          </h3>
          <p className="text-sm opacity-80">
            {featured[i]?.genre} / {featured[i]?.platform}
          </p>
        </div>

        <button
          onClick={() => setI(i === 0 ? featured.length - 1 : i - 1)}
          className="absolute left-4 top-1/2 -translate-y-1/2 bg-white/10 backdrop-blur-md text-white p-3 rounded-full hover:bg-white/20 transition">
          ◀
        </button>

        <button
          onClick={() => setI(i === featured.length - 1 ? 0 : i + 1)}
          className="absolute right-4 top-1/2 -translate-y-1/2 bg-white/10 backdrop-blur-md text-white p-3 rounded-full hover:bg-white/20 transition">
          ▶
        </button>
      </div>

      <div className="flex justify-center mb-6 gap-2">
        {featured.map((_, index) => (
          <div
            key={index}
            className={`h-2 rounded-full transition-all ${
              index === i ? "w-6 bg-indigo-600" : "w-2 bg-gray-300"
            }`}
          />
        ))}
      </div>

      <div className="text-center my-16 px-4">
        <h2 className="text-4xl md:text-5xl font-extrabold text-gray-900 leading-tight">
          Discover <br /> Something New
        </h2>
        <p className="mt-6 text-lg text-gray-600 max-w-xl mx-auto">
          Check out new and upcoming games on the Games Store. 🎮
        </p>
      </div>

      <Show sort={sort} setSort={setSort} />

      <div className="mt-10">
        {filteredGames.length === 0 ? (
          <EmptyState
            onClear={() => {
              setSearch("")
              setSort("new")
            }}
          />
        ) : (
          <GameGrid
            games={filteredGames}
            onAddToWishlist={handleAddToWishlist}
            onRemoveFromWishlist={handleRemoveFromWishlist}
            isInWishlist={(gameId) => isInWishlist(wishlist, gameId)}
          />
        )}
      </div>

    </div>
  )
}