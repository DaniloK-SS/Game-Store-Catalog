defmodule GameStore.Games do
  alias GameStore.Repo
  alias GameStore.Games.Game
  alias GameStore.Cloudinary
  import Ecto.Query

  def list_games(params \\ %{}) do
    Game
    |> filter_by_platform(params["platform"])
    |> filter_by_genre(params["genre"])
    |> filter_by_stock(params["in_stock"] || params["inStock"])
    |> filter_by_search(params["search"])
    |> sort_by(params["sort"])
    |> Repo.all()
  end

  def get_game(id) do
    case Repo.get(Game, id) do
      nil -> {:error, :not_found}
      game -> {:ok, game}
    end
  end

  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  def delete_game(game) do
    case maybe_delete_cover_image(game.cover_image) do
      :ok ->
        Repo.delete(game)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  defp filter_by_platform(query, nil), do: query

  defp filter_by_platform(query, platform) do
    where(query, [g], g.platform == ^platform)
  end

  defp filter_by_genre(query, nil), do: query

  defp filter_by_genre(query, genre) do
    where(query, [g], g.genre == ^genre)
  end

  defp filter_by_stock(query, nil), do: query

  defp filter_by_stock(query, "true") do
    where(query, [g], g.in_stock == true)
  end

  defp filter_by_stock(query, "false") do
    where(query, [g], g.in_stock == false)
  end

  defp filter_by_stock(query, _), do: query

  # Case-insensitive title search using PostgreSQL ILIKE.
  defp filter_by_search(query, nil), do: query

  defp filter_by_search(query, search) do
    where(query, [g], ilike(g.title, ^"%#{search}%"))
  end

  defp sort_by(query, nil), do: query

  defp sort_by(query, "priceLow") do
    order_by(query, [g], asc: g.price)
  end

  defp sort_by(query, "priceHigh") do
    order_by(query, [g], desc: g.price)
  end

  defp sort_by(query, "newest") do
    order_by(query, [g], desc: g.release_year)
  end

  defp sort_by(query, "title") do
    order_by(query, [g], asc: g.title)
  end

  defp sort_by(query, _), do: query

  defp maybe_delete_cover_image(nil), do: :ok
  defp maybe_delete_cover_image(""), do: :ok

  defp maybe_delete_cover_image(url) do
    case Cloudinary.extract_public_id(url) do
      {:ok, public_id} ->
        Cloudinary.delete(public_id)

      :error ->
        :ok
    end
  end
end
