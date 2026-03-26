defmodule GameStoreWeb.Plugs.RequireApiAuth do
  import Plug.Conn

  alias GameStore.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    token_value =
      conn
      |> get_req_header("authorization")
      |> parse_token()

    case Accounts.get_user_by_token(token_value) do
      {:ok, user} ->
        assign(conn, :current_user, user)

      {:error, :unauthorized} ->
        conn
        |> Plug.Conn.put_status(:unauthorized)
        |> Phoenix.Controller.json(%{error: "Unauthorized"})
        |> halt()
    end
  end

  defp parse_token(["Bearer " <> token]), do: token
  defp parse_token(_), do: nil
end
