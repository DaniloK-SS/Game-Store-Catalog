"use client"
import { useSearchParams } from "next/navigation"
import games from "@/app/data/games.json"
import GameGrid from "@/components/GameGrid"
export default function GamesPage() {
  const searchParams = useSearchParams()
  const search = searchParams.get("search") || ""
  const filteredGames = games.filter((game) =>
    game.title.toLowerCase().includes(search.toLowerCase())
  )
  return (
    <div className="max-w-6xl mx-auto p-6">
      <h1 className="text-3xl font-bold mb-6 text-gray-800">
        Game Store
      </h1>
      <GameGrid games={filteredGames} />
    </div>
  )
}