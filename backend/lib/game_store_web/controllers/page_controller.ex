defmodule GameStoreWeb.PageController do
  use GameStoreWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/games")
  end
end
