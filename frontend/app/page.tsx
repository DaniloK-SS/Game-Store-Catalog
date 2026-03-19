"use client"
import { useEffect, useState } from "react"
import games from "@/app/data/games.json"
import GameGrid from "@/components/GameGrid"
import FilterPanel from "@/components/FilterPanel"
import { useSearchParams } from "next/navigation"


const getWishlist = () => {
  const stringList = localStorage.getItem("wishlist")
  return stringList?.split(",").map(x => Number.parseInt(x.trim())).filter(num => Number.isFinite(num) && !Number.isNaN(num)) ?? []
}


const isInWishlist = (wishlist:number[], gameId:number) => {
  return wishlist.some(wishlistId => wishlistId === gameId)
}

export default function HomePage() {
  const search = useSearchParams().get("search") || ""
  const [platform, setPlatform] = useState("")
  const [genre, setGenre] = useState("")
  const [inStock, setInStock] = useState(false)
  const [i, setI] = useState(0)
  const featured = games.filter(g => g.featured).slice(0, 5)
  const [wishlist, setWishlist] = useState<number[]>([])

  console.log(wishlist)

  const handleAddToWishlist = (gameId:number) => {
    const newWishlist= wishlist.concat([gameId])
    setWishlist(newWishlist)
    localStorage.setItem("wishlist", newWishlist.join(","))
  }

    const handleRemoveFromWishlist = (gameId:number) => {
    const newWishlist= wishlist.filter(gid => gid !== gameId)
    setWishlist(newWishlist)
    localStorage.setItem("wishlist", newWishlist.join(","))
  }

  useEffect(() => {
    const wishlist = getWishlist()
    setWishlist(wishlist)
  }, [])

  const filteredGames = games.filter(g =>
    g.title.toLowerCase().includes(search.toLowerCase()) &&
    (platform ? g.platform === platform : true) &&
    (genre ? g.genre === genre : true) &&
    (inStock ? g.inStock : true)
  )
  return (
    <div className="max-w-7xl mx-auto p-6 flex gap-6">
      <div className="w-1/4">
        <FilterPanel
          platform={platform} setPlatform={setPlatform}
          genre={genre} setGenre={setGenre}
          inStock={inStock} setInStock={setInStock}/>
      </div>
      <div className="w-3/4">
        <h2 className="text-2xl font-bold mb-6">Featured Games</h2>
        <div className="relative h-90 rounded-2xl overflow-hidden group shadow-xl mb-6">
          <img
            src={featured[i]?.coverImage}
            className="w-full h-full object-cover transition duration-700 group-hover:scale-105"/>
          <div className="absolute inset-0 bg-linear-to-t from-black/80 via-black/30 to-transparent" />
          <div className="absolute bottom-6 left-6 text-white">
            <h3 className="text-3xl font-bold mb-1">{featured[i]?.title}</h3>
            <p className="text-sm opacity-80">{featured[i]?.genre} / {featured[i]?.platform}</p>
          </div>
          <button
            onClick={() => setI(i === 0 ? featured.length - 1 : i - 1)}
            className="absolute left-4 top-1/2 -translate-y-1/2 bg-white/10 backdrop-blur-md text-white p-3 rounded-full hover:bg-white/20 transition"
          >
          ◀
          </button>
          <button
            onClick={() => setI(i === featured.length - 1 ? 0 : i + 1)}
            className="absolute right-4 top-1/2 -translate-y-1/2 bg-white/10 backdrop-blur-md text-white p-3 rounded-full hover:bg-white/20 transition">
            ▶
          </button>
        </div>
        <div className="flex justify-center mb-6 gap-2">
          {featured.map((_,index) => (
            <div
              key={index}
              className={`h-2 rounded-full transition-all ${
                index === i ? "w-6 bg-indigo-600" : "w-2 bg-gray-300"
              }`}
            />
          ))}
        </div>
        <GameGrid games={filteredGames} onAddToWishlist={handleAddToWishlist} isInWishlist={gameId => {
          return isInWishlist(wishlist, gameId)
        }}
        onRemoveFromWishlist={handleRemoveFromWishlist}
        />
        {filteredGames.length === 0 && (
          <p className="text-center mt-10">We dont have that type of games!</p>
        )}
      </div>
    </div>
  )
}