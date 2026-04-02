defmodule GameStore.Games do
  @moduledoc """
  The games context for listing, querying, and managing store catalog entries.
  """

  alias GameStore.Repo
  alias GameStore.Games.Game
  import Ecto.Query

  @doc """
  Lists games with optional filtering and sorting parameters.

  Expects a params map that may include `"platform"`, `"genre"`, `"in_stock"` or
  `"inStock"`, `"search"`, and `"sort"`.
  Returns a list of `%Game{}` structs matching the query.
  """
  def list_games(params \\ %{}) do
    Game
    |> filter_by_platform(params["platform"])
    |> filter_by_genre(params["genre"])
    |> filter_by_stock(params["in_stock"] || params["inStock"])
    |> filter_by_search(params["search"])
    |> sort_by(params["sort"])
    |> Repo.all()
  end

  @doc """
  Fetches a game by id.

  Expects a game id.
  Returns `{:ok, %Game{}}` when found or `{:error, :not_found}` otherwise.
  """
  def get_game(id) do
    case Repo.get(Game, id) do
      nil -> {:error, :not_found}
      game -> {:ok, game}
    end
  end

  @doc """
  Creates a game from the provided attributes.

  Expects a map of game attributes.
  Returns `{:ok, %Game{}}` on success or `{:error, %Ecto.Changeset{}}` on failure.
  """
  def create_game(attrs) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Uploads a game cover image through the configured image service.

  Expects a local file path.
  Returns `{:ok, image_url}` on success or `{:error, reason}` on failure.
  """
  def upload_cover_image(file_path) do
    image_service().upload(file_path)
  end

  @doc """
  Updates an existing game.

  Expects a `%Game{}` struct and a map of attributes.
  Returns `{:ok, %Game{}}` on success or `{:error, %Ecto.Changeset{}}` on failure.
  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game and attempts to remove its stored cover image first.

  Expects a `%Game{}` struct.
  Returns `{:ok, %Game{}}` when deletion succeeds or `{:error, reason}` when image
  cleanup or database deletion fails.
  """
  def delete_game(%Game{} = game) do
    case maybe_delete_cover_image(game.cover_image) do
      :ok ->
        Repo.delete(game)

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Builds a changeset for a game without persisting it.

  Expects a `%Game{}` struct and an optional attribute map.
  Returns an `Ecto.Changeset`.
  """
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
    case image_service().extract_public_id(url) do
      {:ok, public_id} ->
        image_service().delete(public_id)

      :error ->
        :ok
    end
  end

  defp image_service do
    Application.fetch_env!(:game_store, :image_service)
  end
end
