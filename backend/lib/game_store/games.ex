defmodule GameStore.Games do
  alias GameStore.Repo
  alias GameStore.Games.Game
  import Ecto.Query


  def list_games(params \\ %{}) do
  Game
  |> filter_by_platform(params["platform"])
  |> filter_by_genre(params["genre"])
  |> filter_by_stock(params["in_stock"])
  |> filter_by_search(params["search"])
  |> Repo.all()
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
  defp filter_by_stock(query, in_stock) do
    where(query, [g], g.in_stock == ^(in_stock == "true"))
  end

  defp filter_by_search(query, nil), do: query
  defp filter_by_search(query, search) do
    where(query, [g], ilike(g.title, ^"%#{search}%"))
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

end
