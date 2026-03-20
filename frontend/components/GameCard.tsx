import Link from "next/link";
import { Game } from "../app/types/game";
import { MdPlaylistAddCheck } from "react-icons/md";
type Props = {
  game: Game;
  isInWishlist: (gameId:number) => boolean,
  onAddToWishlist: (gameId:number) => void
  onRemoveFromWishlist: (gameId:number) => void
};
export default function GameCard({ game, onAddToWishlist, isInWishlist, onRemoveFromWishlist }: Props) {


  const inWishlist = isInWishlist(game.id)
  return (
    <Link
      href={`/games/${game.id}`}
      className="border rounded-lg overflow-hidden shadow-sm 
                 hover:shadow-lg hover:-translate-y-1 
                 transition duration-200 cursor-pointer block"
    >
      <img
        src={game.coverImage}
        alt={game.title}
        className="w-full h-48 object-cover"
      />
      <div className="p-4">
        <h2 className="text-xl font-semibold">{game.title}</h2>
        <p className="text-gray-500">{game.genre}</p>
        <p className="text-gray-500">{game.platform}</p>
        <p className="font-bold mt-2">${game.price}</p>
        <p
          className={`mt-2 text-sm font-medium 
          ${game.inStock ? "text-green-600" : "text-red-600"}`}
        >
          {game.inStock ? "In Stock" : "Out of Stock"}
        </p>
        <button
          onClick={(e) => {
            e.preventDefault();
            console.log("Add to wishlist:", game.title);
            if (inWishlist) {
              onRemoveFromWishlist(game.id)
            } else {
              onAddToWishlist(game.id)
            }
          }}
         className={`mt-3 w-full flex items-center justify-center gap-2 
            py-2 rounded-md transition 
            ${inWishlist 
              ? "bg-gray-600 text-white hover:bg-gray-700" 
              : "bg-indigo-600 text-white hover:bg-indigo-700"
            }`}
        >
          <MdPlaylistAddCheck />
          {inWishlist ? "Remove from Wishlist":"Add to Wishlist"}
        </button>
      </div>
    </Link>
  );
}
