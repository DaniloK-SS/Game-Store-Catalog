defmodule GameStoreWeb.GameJSON do
  def index(%{games: games}) do
    %{data: Enum.map(games, &game/1)}
  end

  def show(%{game: game}) do
    %{data: game(game)}
  end

  def error(assigns) do
    %{error: assigns.message}
    |> maybe_put(:received, Map.get(assigns, :received))
    |> maybe_put(:allowed, Map.get(assigns, :allowed))
  end

  defp game(game) do
    %{
      id: game.id,
      title: game.title,
      genre: game.genre,
      platform: game.platform,
      price: game.price,
      releaseYear: game.release_year,
      publisher: game.publisher,
      coverImage: game.cover_image,
      description: game.description,
      inStock: game.in_stock,
      featured: game.featured
    }
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end
