import Link from "next/link"
import { Game } from "../app/types/game"
import { MdPlaylistAddCheck } from "react-icons/md"
type Props = {
  game: Game
}
export default function GameCard({ game }: Props) {
  return (
    <Link
      href={`/games/${game.id}`}
      className="border rounded-lg overflow-hidden shadow-sm 
                 hover:shadow-lg hover:-translate-y-1 
                 transition duration-200 cursor-pointer block">
      <img
        src={game.coverImage}
        alt={game.title}
        className="w-full h-48 object-cover"/>
      <div className="p-4">
        <h2 className="text-xl font-semibold">{game.title}</h2>
        <p className="text-gray-500">{game.genre}</p>
        <p className="text-gray-500">{game.platform}</p>
        <p className="font-bold mt-2">${game.price}</p>
        <p className={`mt-2 text-sm font-medium 
          ${game.inStock 
            ? "text-green-600" 
            : "text-red-600"}`}>
          {game.inStock ? "In Stock" : "Out of Stock"}
        </p>
        <button
          onClick={(e) => {
            e.preventDefault()
            console.log("Add to wishlist:", game.title)
          }}
          className="mt-3 w-full flex items-center justify-center gap-2 
                     bg-indigo-600 text-white py-2 rounded-md 
                     hover:bg-indigo-900 transition"
        ><MdPlaylistAddCheck />Add to Wishlist</button>
      </div>
    </Link>
  )
}