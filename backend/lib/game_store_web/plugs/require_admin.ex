defmodule GameStoreWeb.Plugs.RequireAdmin do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && GameStore.Accounts.get_user(user_id)

    if user && user.role == "admin" do
      assign(conn, :current_user, user)
    else
      conn
      |> put_flash(:error, "You must be logged in as admin")
      |> redirect(to: "/admin/login")
      |> halt()
    end
  end
end
