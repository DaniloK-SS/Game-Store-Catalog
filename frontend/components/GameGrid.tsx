import GameCard from "./GameCard"
import { Game } from "../app/types/game"
type Props = { //tip ocekuje jedan game objekat
  games: Game[];
  isInWishlist: (gameId:number) => boolean,
  onAddToWishlist: (gameId:number) => void
  onRemoveFromWishlist: (gameId:number) => void
}
export default function GameGrid({ games, onAddToWishlist, isInWishlist ,onRemoveFromWishlist}: Props) {
  if (games.length === 0) {
    return (
      <p className="text-gray-500 text-center mt-10">
        No games found.
      </p>
    )
  }
  return (
    <div className="grid grid-cols-2 md:grid-cols-3 gap-6">
      {games.map((game) => (
        <GameCard key={game.id} game={game} onAddToWishlist={onAddToWishlist} isInWishlist={isInWishlist} onRemoveFromWishlist={onRemoveFromWishlist} />
      ))}
    </div>
  )
}