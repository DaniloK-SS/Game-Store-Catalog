defmodule GameStore.Games do
  alias GameStore.Repo
  alias GameStore.Games.Game
  import Ecto.Query

  # Returns all games applying any filters and sort
  # passed in as params from the controller or LiveView.
  def list_games(params \\ %{}) do
    Game
    |> filter_by_platform(params["platform"])
    |> filter_by_genre(params["genre"])
    |> filter_by_stock(params["in_stock"] || params["inStock"])
    |> filter_by_search(params["search"])
    |> sort_by(params["sort"])
    |> Repo.all()
  end

  # Passes query through if no platform filter provided.
  # Otherwise filters by exact platform match.
  defp filter_by_platform(query, nil), do: query

  defp filter_by_platform(query, platform) do
    where(query, [g], g.platform == ^platform)
  end

  # Passes query through if no genre filter provided.
  # Otherwise filters by exact genre match.
  defp filter_by_genre(query, nil), do: query

  defp filter_by_genre(query, genre) do
    where(query, [g], g.genre == ^genre)
  end

  # Handles both "in_stock" (backend convention) and
  # "inStock" (frontend convention) as param keys.
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

  # Sorts games by the given sort key.
  # Passes the query through unchanged if no sort key provided.
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

  # Fetches a single game by ID.
  # Returns {:ok, game} if found, {:error, :not_found} if not.
  def get_game(id) do
    case Repo.get(Game, id) do
      nil -> {:error, :not_found}
      game -> {:ok, game}
    end
  end

  # Inserts a new game into the database.
  # Returns {:ok, game} on success, {:error, changeset} on failure.
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  # Updates an existing game with the provided attributes.
  # Returns {:ok, game} on success, {:error, changeset} on failure.
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  # Deletes a game from the database.
  # Returns {:ok, game} on success.
  def delete_game(game) do
    case maybe_delete_cover_image(game.cover_image) do
      :ok ->
        Repo.delete(game)

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp maybe_delete_cover_image(nil), do: :ok
  defp maybe_delete_cover_image(""), do: :ok

  defp maybe_delete_cover_image(url) do
    case GameStore.Cloudinary.extract_public_id(url) do
      {:ok, public_id} ->
        GameStore.Cloudinary.delete(public_id)

      :error ->
        :ok
    end
  end

  # Returns a changeset for tracking form changes.
  # Used by LiveView forms to validate input before saving.
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end
end
