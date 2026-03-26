defmodule GameStoreWeb.UserController do
  use GameStoreWeb, :controller

  alias GameStore.Accounts

  action_fallback GameStoreWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def update_role(conn, %{"id" => id, "role" => role}) do
    current_user = conn.assigns.current_user

    with {:ok, user} <- Accounts.update_user_role(id, role, current_user) do
      render(conn, :show, user: user)
    end
  end
end
