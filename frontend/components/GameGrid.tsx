import GameCard from "./GameCard"
import { Game } from "../app/types/game"

type Props = {
  games: Game[];
  limit?: number;
  isInWishlist?: (gameId: number) => boolean;
  onAddToWishlist?: (gameId: number) => void;
  onRemoveFromWishlist?: (gameId: number) => void;
}

export default function GameGrid({
  games,
  limit,
  onAddToWishlist,
  isInWishlist,
  onRemoveFromWishlist
}: Props) {
  const visibleGames = limit ? (games || []).slice(0, limit) : games

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
      {visibleGames.map((game) => (
        <GameCard
          key={game.id}
          game={game}
          onAddToWishlist={onAddToWishlist || (() => {})}
          onRemoveFromWishlist={onRemoveFromWishlist || (() => {})}
          isInWishlist={isInWishlist || (() => false)}
        />
      ))}
    </div>
  )
}