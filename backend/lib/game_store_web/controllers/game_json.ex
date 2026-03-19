defmodule GameStoreWeb.GameJSON do


  def index(%{games: games}) do
    %{data: Enum.map(games, &game/1)}
  end

  def show(%{game: game}) do
    %{data: game(game)}
  end

  def error(%{message: message}) do
    %{error: message}
  end

  defp game(game) do
    %{
      id: game.id,
      title: game.title,
      genre: game.genre,
      platform: game.platform,
      price: game.price,
      release_year: game.release_year,
      publisher: game.publisher,
      cover_image: game.cover_image,
      description: game.description,
      in_stock: game.in_stock,
      featured: game.featured
    }
  end
end
