"use client"

import { useEffect, useState } from "react"
import GameGrid from "@/components/GameGrid"
import EmptyWishlist from "@/components/EmptyWishList"
import { getGames } from "@/lib/GetGames"

const getWishlist = () => {
  const stringList = localStorage.getItem("wishlist")

  return stringList?.split(",")
    .map(x => Number(x.trim())) // ✅ uvijek number
    .filter(num => !isNaN(num)) ?? []
}

const isInWishlist = (wishlist: number[], gameId: number) => {
  return wishlist.some(id => id === gameId)
}

export default function WishlistPage() {
  const [wishlist, setWishlist] = useState<number[]>([])
  const [games, setGames] = useState<any[]>([]) //  API games

  useEffect(() => {
    async function fetchData() {
      const data = await getGames()

      const parsedGames = Array.isArray(data)
        ? data
        : data?.data || data?.games || []

      // normalizacija
      const normalizedGames = parsedGames.map((g: any) => ({
        ...g,
        id: Number(g.id),
        price: Number(g.price),
      }))

      setGames(normalizedGames)
    }

    fetchData()
    setWishlist(getWishlist())
  }, [])

  const handleRemoveFromWishlist = (gameId: number) => {
    const newWishlist = wishlist.filter(id => id !== gameId)
    setWishlist(newWishlist)
    localStorage.setItem("wishlist", newWishlist.join(","))
  }

   
  const wishlistGames = games.filter(game =>
    wishlist.includes(game.id)
  )

  return (
    <div className="max-w-6xl mx-auto p-6">

      <h1 className="text-3xl font-bold mb-6 text-gray-800">
        Your Wishlist
      </h1>

      {wishlistGames.length === 0 ? (
        <EmptyWishlist />
      ) : (
        <GameGrid
          games={wishlistGames}
          onAddToWishlist={() => {}}
          onRemoveFromWishlist={handleRemoveFromWishlist}
          isInWishlist={(gameId) => isInWishlist(wishlist, gameId)}
        />
      )}

    </div>
  )
}