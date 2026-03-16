import games from "./data/games.json"

export default function GamesPage() {
  return (
    <div className="max-w-6xl mx-auto p-6">
      <h1 className="text-3xl font-bold mb-6">Game Store</h1>
      <div className="grid grid-cols-3 gap-6">
        {games.map((game) => (
          <div
            key={game.id}
            className="border rounded-lg overflow-hidden shadow-sm 
                       hover:shadow-lg hover:-translate-y-1 
                       transition duration-200 cursor-pointer"
          >
            <img
              src={game.coverImage}
              alt={game.title}
              className="w-full h-48 object-cover"/>

            <div className="p-4">

              <h2 className="text-xl font-semibold">{game.title}</h2>
              <p className="text-gray-500">{game.genre}</p>
              <p className="text-gray-500">{game.platform}</p>
              <p className="font-bold mt-2">${game.price}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}