defmodule GameStoreWeb.GameController do
  use GameStoreWeb, :controller

  alias GameStore.Games

  # Returns a list of all games.
  # Accepts optional query params for filtering (platform, genre, in_stock, search).
  def index(conn, params) do
    games = Games.list_games(params)
    render(conn, :index, games: games)
  end

  # Returns a single game by ID.
  # Responds with 404 if the game does not exist.
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

  # Creates a new game from the request body.
  # Responds with 201 and the created game on success.
  # Responds with 400 and an error message if validation fails.
  def create(conn, %{"game" => game_params}) do
    case Games.create_game(game_params) do
      {:ok, game} ->
        conn
        |> put_status(:created)
        |> render(:show, game: game)

      {:error, _changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(:error, message: "Invalid game data")
    end
  end

  # Deletes a game by ID.
  # Responds with 404 if the game does not exist.
  # Responds with 200 and the deleted game on success.
  # Responds with 500 if image cleanup fails.
  def delete(conn, %{"id" => id}) do
    case Games.get_game(id) do
      {:ok, game} ->
        case Games.delete_game(game) do
          {:ok, _deleted_game} ->
            render(conn, :show, game: game)

          {:error, reason} ->
            conn
            |> put_status(:internal_server_error)
            |> render(:error, message: "Failed to delete game: #{inspect(reason)}")
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> render(:error, message: "Game not found")
    end
  end

  # Updates a game by ID with the provided fields.
  # Responds with 404 if the game does not exist.
  # Responds with 400 if validation fails.
  # Responds with 200 and the updated game on success.
  def update(conn, %{"id" => id, "game" => game_params}) do
    case Games.get_game(id) do
      {:ok, game} ->
        case Games.update_game(game, game_params) do
          {:ok, updated_game} ->
            render(conn, :show, game: updated_game)

          {:error, _changeset} ->
            conn
            |> put_status(:bad_request)
            |> render(:error, message: "Invalid game data")
        end

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> render(:error, message: "Game not found")
    end
  end
end
