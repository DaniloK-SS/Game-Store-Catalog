"use client"
import { useEffect, useState } from "react"
import { useSearchParams } from "next/navigation"
import games from "@/app/data/games.json"
import GameGrid from "@/components/GameGrid"

const getWishlist = () => {
  const stringList = localStorage.getItem("wishlist")
  return stringList?.split(",")
    .map(x => Number.parseInt(x.trim()))
    .filter(num => Number.isFinite(num) && !Number.isNaN(num)) ?? []
}
const isInWishlist = (wishlist:number[], gameId:number) => {
  return wishlist.some(id => id === gameId)
}
export default function GamesPage() {
  const search = useSearchParams().get("search") || ""
  const [wishlist, setWishlist] = useState<number[]>([])

  useEffect(() => {
    setWishlist(getWishlist())
  }, [])
  const handleAddToWishlist = (gameId:number) => {
    const newWishlist = wishlist.concat([gameId])
    setWishlist(newWishlist)
    localStorage.setItem("wishlist", newWishlist.join(","))
  }
  const handleRemoveFromWishlist = (gameId:number) => {
    const newWishlist = wishlist.filter(id => id !== gameId)
    setWishlist(newWishlist)
    localStorage.setItem("wishlist", newWishlist.join(","))
  }
  const filteredGames = games.filter((game) =>
    game.title.toLowerCase().includes(search.toLowerCase())
  )
  return (
    <div className="max-w-6xl mx-auto p-6">
      <h1 className="text-3xl font-bold mb-6 text-gray-800">
        Game Store
      </h1>
      <GameGrid
        games={filteredGames}
        onAddToWishlist={handleAddToWishlist}
        onRemoveFromWishlist={handleRemoveFromWishlist}
        isInWishlist={(gameId) => isInWishlist(wishlist, gameId)}
      />
    </div>
  )
}