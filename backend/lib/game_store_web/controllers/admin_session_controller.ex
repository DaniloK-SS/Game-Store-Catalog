defmodule GameStoreWeb.AdminSessionController do
  use GameStoreWeb, :controller

  # Renders the login form.
  def new(conn, _params) do
    render(conn, :new)
  end

  # Handles the login form submission.
  # Compares the submitted password against the one in config.
  # On success — sets the admin session flag and redirects to the admin panel.
  # On failure — re-renders the login form with an error message.
  def create(conn, %{"password" => password}) do
    admin_password = Application.get_env(:game_store, :admin_password)

    if password == admin_password do
      conn
      |> put_session(:admin, true)
      |> redirect(to: "/admin/games")
    else
      conn
      |> put_flash(:error, "Invalid password")
      |> render(:new)
    end
  end

  # Clears the admin session and redirects to the login page.
  def delete(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: "/admin/login")
  end
end
