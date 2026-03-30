defmodule GameStoreWeb.Plugs.RequireAdmin do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :render_token) do
      nil ->
        conn
        |> put_flash(:error, "You must be logged in as admin")
        |> redirect(to: "/admin/login")
        |> halt()

      _token ->
        conn
    end
  end
end
