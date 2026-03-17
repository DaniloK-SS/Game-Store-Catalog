import games from "../../data/games.json"
import { notFound } from "next/navigation" //404 not found funkcija
type Props = {
  params: Promise<{
    id: string
  }>
}
export default async function GameDetailsPage({ params }: Props) {
  const { id } = await params   // fetchovanje 
  const game = games.find(
    (g) => String(g.id) === id // trazi games po ID
  )
  if (!game) {
    return notFound() //404
  }
  return (
  <div className="max-w-5xl mx-auto p-6">
    <div className="overflow-hidden rounded-xl shadow-md group">
  <img
    src={game.coverImage}
    alt={game.title}
    className="w-full h-96 object-cover transition duration-500 group-hover:scale-105"
  />
</div>
    <div className="mt-8 bg-white rounded-xl shadow-sm p-6 transition duration-300 hover:shadow-lg hover:-translate-y-1">
      <h1 className="text-3xl font-bold text-gray-900 mb-4">
        {game.title}
      </h1>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-gray-700">
        <p><span className="font-semibold">Genre:</span> {game.genre}</p>
        <p><span className="font-semibold">Platform:</span> {game.platform}</p>
        <p><span className="font-semibold">Price:</span> ${game.price}</p>
        <p><span className="font-semibold">Release Year:</span> {game.releaseYear}</p>
        <p><span className="font-semibold">Publisher:</span> {game.publisher}</p>
        <p>
          <span className="font-semibold">Status:</span>
          <span className={`px-2 py-1 rounded-md text-sm font-medium 
            ${game.inStock 
              ? "bg-green-100 text-green-700" 
              : "bg-red-100 text-red-700"}`}>
            {game.inStock ? "In Stock" : "Out of Stock"}
          </span>
        </p>
      </div>
      <div className="mt-6 border-t pt-4">
        <p className="text-gray-600 leading-relaxed">
          {game.description}
        </p>
      </div>

    </div>

  </div>
)
}