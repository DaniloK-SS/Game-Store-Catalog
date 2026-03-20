defmodule GameStoreWeb.Plugs.RequireAdmin do
  import Plug.Conn
  import Phoenix.Controller

  # This plug runs on every request to the admin pipeline.
  # It checks if the session has the admin flag set to true.
  # If yes — the request continues normally.
  # If no — the user gets redirected to the login page.
  def init(opts), do: opts

  def call(conn, _opts) do
    if get_session(conn, :admin) do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in as admin")
      |> redirect(to: "/admin/login")
      |> halt()
    end
  end
end
