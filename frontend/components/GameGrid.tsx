import GameCard from "./GameCard"
import { Game } from "../app/types/game"
type Props = { //tip ocekuje jedan game objekat
  games: Game[]
}
export default function GameGrid({ games }: Props) {
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
        <GameCard key={game.id} game={game} />
      ))}
    </div>
  )
}