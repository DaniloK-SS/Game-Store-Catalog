"use client"
import Link from "next/link";
import { Game } from "../app/types/game";
import { MdPlaylistAddCheck } from "react-icons/md";
import { CiBookmarkPlus, CiBookmarkRemove } from "react-icons/ci";

type Props = {
  game: Game;
  isInWishlist: (gameId: number) => boolean,
  onAddToWishlist: (gameId: number) => void
  onRemoveFromWishlist: (gameId: number) => void
};

export default function GameCard({
  game,
  onAddToWishlist,
  isInWishlist,
  onRemoveFromWishlist
}: Props) {

  const inWishlist = isInWishlist(game.id)

  return (
    <Link
      href={`/games/${game.id}`}
      className="group border rounded-xl overflow-hidden bg-white 
                 hover:shadow-xl hover:-translate-y-2 
                 hover:ring-2 hover:ring-indigo-500/40
                 transition-all duration-300 cursor-pointer block"
    >
      <div className="relative overflow-hidden">
        <img
          src={game.coverImage}
          alt={game.title}
          className="w-full h-48 object-cover 
                     group-hover:scale-110 transition duration-500"
        />

        <div className="absolute inset-0 bg-black/0 group-hover:bg-black/30 transition duration-300" />

        <button
          onClick={(e) => {
            e.preventDefault()
            if (inWishlist) {
              onRemoveFromWishlist(game.id)
            } else {
              onAddToWishlist(game.id)
            }
          }}
          className={`absolute top-3 right-3 md:hidden
            p-2.5 rounded-full 
            backdrop-blur-xl 
            border transition-all duration-300 
            shadow-lg hover:scale-110 active:scale-95
            ${inWishlist
              ? "bg-indigo-600/90 border-indigo-500 text-white shadow-indigo-500/30"
              : "bg-white/70 border-white/40 text-indigo-600 hover:bg-white"
            }
          `}
        >
          {inWishlist ? (
            <CiBookmarkRemove className="text-2xl drop-shadow-sm" />
          ) : (
            <CiBookmarkPlus className="text-2xl drop-shadow-sm" />
          )}
        </button>
      </div>

      <div className="p-4">
        <h2 className="text-xl font-semibold group-hover:text-indigo-600 transition">
          {game.title}
        </h2>

        <p className="text-gray-500 text-sm">{game.platform}</p>

        <p className="font-bold mt-2 text-lg text-black-600">
          ${game.price}
        </p>

        <p className={`mt-2 text-xs font-semibold px-2 py-1 rounded-full inline-block
          ${game.inStock 
            ? "bg-green-100 text-green-700" 
            : "bg-red-100 text-red-600"
          }`}
        >
          {game.inStock ? "In Stock" : "Out of Stock"}
        </p>

        <button
          onClick={(e) => {
            e.preventDefault();
            if (inWishlist) {
              onRemoveFromWishlist(game.id)
            } else {
              onAddToWishlist(game.id)
            }
          }}
          className={`mt-4 w-full hidden md:flex items-center justify-center gap-2 
            py-2 rounded-md transition-all duration-200
            hover:scale-[1.02] active:scale-95
            ${inWishlist 
              ? "bg-gray-600 text-white hover:bg-gray-700" 
              : "bg-indigo-600 text-white hover:bg-indigo-700"
            }`}
        >
          <MdPlaylistAddCheck />
          {inWishlist ? "Remove from Wishlist" : "Add to Wishlist"}
        </button>
      </div>
    </Link>
  );
}