"use client"

import { useEffect, useState } from "react"
import { useParams } from "next/navigation"
import { getGames } from "@/lib/GetGames"
import Link from "next/link"

export default function GameDetailsPage() {
  const params = useParams()
  const id = Number(params.id)

  const [game, setGame] = useState<any>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function fetchGame() {
      const data = await getGames()

      const parsedGames = Array.isArray(data)
        ? data
        : data?.data || data?.games || []

      const normalizedGames = parsedGames.map((g: any) => ({
        ...g,
        id: Number(g.id),
        price: Number(g.price),
      }))

      const foundGame = normalizedGames.find((g:any) => g.id === id)

      setGame(foundGame)
      setLoading(false)
    }

    fetchGame()
  }, [id])

  // 🔄 LOADING
  if (loading) {
    return (
      <div className="p-10 text-center text-gray-500">
        Loading game...
      </div>
    )
  }
  if (!game) {
    return (
      <div className="p-10 text-center">
        <h2 className="text-2xl font-bold mb-4">Game not found</h2>
        <Link href="/" className="text-indigo-600 underline">
          Back to Home
        </Link>
      </div>
    )
  }
  return (
    <div className="max-w-5xl mx-auto p-6">

      <div className="overflow-hidden rounded-xl shadow-md group">
        <img
          src={game.coverImage}
          alt={game.title}
          className="w-full h-96 object-cover transition duration-500 group-hover:scale-105"
        />
      </div>

      <div className="mt-8 bg-white rounded-xl shadow-sm p-6 transition duration-300 hover:shadow-lg hover:-translate-y-1">

        <h1 className="text-3xl font-bold text-gray-900 mb-4">
          {game.title}
        </h1>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-gray-700">
          <p><span className="font-semibold">Genre:</span> {game.genre}</p>
          <p><span className="font-semibold">Platform:</span> {game.platform}</p>
          <p><span className="font-semibold">Price:</span> ${game.price}</p>
          <p><span className="font-semibold">Release Year:</span> {game.releaseYear}</p>
          <p><span className="font-semibold">Publisher:</span> {game.publisher}</p>

          <p>
            <span className="font-semibold">Status:</span>
            <span className={`ml-2 px-2 py-1 rounded-md text-sm font-medium 
              ${game.inStock 
                ? "bg-green-100 text-green-700" 
                : "bg-red-100 text-red-700"}`}>
              {game.inStock ? "In Stock" : "Out of Stock"}
            </span>
          </p>
        </div>

        <div className="mt-6 border-t pt-4">
          <p className="text-gray-600 leading-relaxed">
            {game.description}
          </p>
        </div>

      </div>

    </div>
  )
}