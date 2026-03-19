defmodule GameStoreWeb.GameController do
  use GameStoreWeb, :controller

  alias GameStore.Games

  def index(conn, params) do
    games = Games.list_games(params)
    render(conn, :index, games: games)
  end

  def show(conn, %{"id" => id}) do
    case Games.get_game(id) do
      {:ok, game} ->
        render(conn, :show, game: game)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> render(:error, message: "Game not found")
    end
  end
end
