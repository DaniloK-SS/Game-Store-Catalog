"use client"

import { useEffect, useState } from "react"
import games from "@/app/data/games.json"
import GameGrid from "@/components/GameGrid"
import EmptyWishlist from "@/components/EmptyWishList"

const getWishlist = () => {
  const stringList = localStorage.getItem("wishlist")
  return stringList?.split(",")
    .map(x => Number.parseInt(x.trim()))
    .filter(num => Number.isFinite(num) && !Number.isNaN(num)) ?? [] //array brojeva[gameId]
}

const isInWishlist = (wishlist: number[], gameId: number) => { //cuvam ID igrice
  return wishlist.some(id => id === gameId)
}

export default function WishlistPage() {
  const [wishlist, setWishlist] = useState<number[]>([])

  useEffect(() => {
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