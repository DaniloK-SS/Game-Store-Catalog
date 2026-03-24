defmodule GameStoreWeb.AdminSessionController do
  use GameStoreWeb, :controller


  def new(conn, _params) do
    render(conn, :new)
  end


  def create(conn, %{"email" => email, "password" => password}) do
    case GameStore.Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        if user.role == "admin" do
          conn
          |> put_session(:user_id, user.id)
          |> redirect(to: "/admin/games")
        else
          conn
          |> put_flash(:error, "Invalid credentials.")
          |> render(:new)
        end

      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Invalid credentials.")
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
