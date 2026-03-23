"use client"
import { useEffect, useState } from "react"
import games from "@/app/data/games.json"
import GameGrid from "@/components/GameGrid"
import FilterPanel from "@/components/FilterPanel"
import { useSearch } from "@/components/SearchContext"
import EmptyState from "@/components/EmptyState"

const getWishlist = () => {
  const stringList = localStorage.getItem("wishlist")
  return stringList?.split(",")
    .map(x => Number.parseInt(x.trim()))
    .filter(num => Number.isFinite(num) && !Number.isNaN(num)) ?? []
}

const isInWishlist = (wishlist: number[], gameId: number) => {
  return wishlist.some(id => id === gameId)
}

export default function GamesPage() {
  const { search, setSearch } = useSearch()

  const [wishlist, setWishlist] = useState<number[]>([])
  const [platform, setPlatform] = useState("")
  const [genre, setGenre] = useState("")
  const [inStock, setInStock] = useState(false)
  const [sort, setSort] = useState("")

  useEffect(() => {
    setWishlist(getWishlist())
  }, []) //ucitavanje kad se stranica pokrene

  const handleAddToWishlist = (gameId: number) => {
    const newWishlist = wishlist.concat([gameId])
    setWishlist(newWishlist)
    localStorage.setItem("wishlist", newWishlist.join(","))
  }

  const handleRemoveFromWishlist = (gameId: number) => {
    const newWishlist = wishlist.filter(id => id !== gameId)
    setWishlist(newWishlist)
    localStorage.setItem("wishlist", newWishlist.join(","))
  }

  const filteredGames = games
    .filter((game) => {
      const matchesSearch = game.title
        .toLowerCase()
        .includes(search.toLowerCase())

      const matchesPlatform = platform
        ? game.platform === platform
        : true

      const matchesGenre = genre
        ? game.genre === genre
        : true

      const matchesStock = inStock
        ? game.inStock === true
        : true

      return (
        matchesSearch &&
        matchesPlatform &&
        matchesGenre &&
        matchesStock
      )
    })
    .sort((a, b) => {
      switch (sort) {
        case "priceLow":
          return a.price - b.price
        case "priceHigh":
          return b.price - a.price
        case "newest":
          return b.releaseYear - a.releaseYear
        case "title":
          return a.title.localeCompare(b.title)
        default:
          return 0
      }
    })

  return (
    <div className="max-w-6xl mx-auto p-6">

      <h1 className="text-3xl font-bold mb-6 text-gray-800">
        Game Store
      </h1>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">

        <div className="md:col-span-1">
          <FilterPanel
            platform={platform}
            setPlatform={setPlatform}
            genre={genre}
            setGenre={setGenre}
            inStock={inStock}
            setInStock={setInStock}
            sort={sort}
            setSort={setSort}
          />
        </div>

        <div className="md:col-span-3">

          {filteredGames.length === 0 ? (
            <EmptyState
              onClear={() => {
                setPlatform("")
                setGenre("")
                setInStock(false)
                setSort("")
                setSearch("")
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
    </div>
  )
}