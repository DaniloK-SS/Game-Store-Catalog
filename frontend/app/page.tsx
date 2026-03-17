"use client"

import { useState } from "react"
import games from "@/app/data/games.json"
import GameGrid from "../components/GameGrid"
import Navbar from "../components/Navbar"

export default function GamesPage() {
  const [search, setSearch] = useState("")

  const filteredGames = games.filter((game) =>
    game.title.toLowerCase().includes(search.toLowerCase())
  )

  return (
    <>
      <Navbar search={search} setSearch={setSearch} />
      <div className="max-w-6xl mx-auto p-6">
        <h1 className="text-3xl font-bold mb-6 text-gray-800">
          Game Store
        </h1>
        <GameGrid games={filteredGames} />
      </div>
    </>
  )
}