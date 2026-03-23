defmodule GameStore.Games do
  alias GameStore.Repo
  alias GameStore.Games.Game
  import Ecto.Query

  # Returns all games, applying any filters passed in as params.
  # Supports filtering by platform, genre, in_stock, and search.
  def list_games(params \\ %{}) do
    Game
    |> filter_by_platform(params["platform"])
    |> filter_by_genre(params["genre"])
    |> filter_by_stock(params["in_stock"])
    |> filter_by_search(params["search"])
    |> Repo.all()
  end

  # Passes the query through unchanged if no platform filter is provided.
  # Otherwise filters games by exact platform match.
  defp filter_by_platform(query, nil), do: query

  defp filter_by_platform(query, platform) do
    where(query, [g], g.platform == ^platform)
  end

  # Passes the query through unchanged if no genre filter is provided.
  # Otherwise filters games by exact genre match.
  defp filter_by_genre(query, nil), do: query

  defp filter_by_genre(query, genre) do
    where(query, [g], g.genre == ^genre)
  end

  # Passes the query through unchanged if no in_stock filter is provided.
  # Converts the "true"/"false" string from query params to a boolean.
  defp filter_by_stock(query, nil), do: query

  defp filter_by_stock(query, in_stock) do
    where(query, [g], g.in_stock == ^(in_stock == "true"))
  end

  # Passes the query through unchanged if no search term is provided.
  # Otherwise does a case-insensitive title search using ILIKE.
  defp filter_by_search(query, nil), do: query

  defp filter_by_search(query, search) do
    where(query, [g], ilike(g.title, ^"%#{search}%"))
  end

  # Fetches a single game by ID.
  # Returns {:ok, game} if found, {:error, :not_found} if not.
  def get_game(id) do
    case Repo.get(Game, id) do
      nil -> {:error, :not_found}
      game -> {:ok, game}
    end
  end

  # Inserts a new game into the database using the provided attributes.
  # Returns {:ok, game} on success, {:error, changeset} on validation failure.
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  # Updates an existing game with the provided attributes.
  # Returns {:ok, game} on success, {:error, changeset} on validation failure.
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  # Deletes a game from the database.
  # Returns {:ok, game} on success.
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end
end
