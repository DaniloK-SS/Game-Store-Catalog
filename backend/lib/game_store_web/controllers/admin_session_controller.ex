defmodule GameStoreWeb.AdminSessionController do
  use GameStoreWeb, :controller

  alias GameStore.RenderAPI

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case RenderAPI.login(email, password) do
      {:ok, token} ->
        conn
        |> put_session(:render_token, token)
        |> redirect(to: "/admin/games")

      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Invalid credentials.")
        |> render(:new)

      {:error, :forbidden} ->
        conn
        |> put_flash(:error, "Not authorized as admin.")
        |> render(:new)

      {:error, :request_failed} ->
        conn
        |> put_flash(:error, "Unable to reach authentication service.")
        |> render(:new)
    end
  end

  # Clears the session and redirects to the login page.
  def delete(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: "/admin/login")
  end
end
