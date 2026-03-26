defmodule GameStoreWeb.Api.SessionController do
  use GameStoreWeb, :controller

  alias GameStore.Accounts

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        if user.role == "admin" do
          {:ok, token} = Accounts.create_token(user)

          conn
          |> put_status(:created)
          |> json(%{token: token.token})
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Insufficient permissions"})
        end

      {:error, :invalid_credentials} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end

  @doc """
  Logout. Reads the token from the Authorization header
  and deletes it from the database.
  After this the token is dead and can never be used again.
  """
  def delete(conn, _params) do
    token_value =
      conn
      |> get_req_header("authorization")
      |> parse_token()

    Accounts.delete_token(token_value)

    conn
    |> put_status(:ok)
    |> json(%{message: "Logged out successfully"})
  end

  # Extracts the token string from the Authorization header.
  # The header comes in as "Bearer abc123xyz" so we split
  # on the space and take the second part.
  defp parse_token(["Bearer " <> token]), do: token
  defp parse_token(_), do: nil
end
