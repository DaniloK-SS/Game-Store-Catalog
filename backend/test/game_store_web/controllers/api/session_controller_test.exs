defmodule GameStoreWeb.Api.SessionControllerTest do
  use GameStoreWeb.ConnCase, async: true

  alias GameStore.Accounts

  describe "create/2" do
    test "returns a token for valid admin credentials", %{conn: conn} do
      admin = admin_user_fixture(%{email: "admin@example.com", password: "supersecret"})

      conn =
        post(conn, ~p"/api/sessions", %{
          "email" => "admin@example.com",
          "password" => "supersecret"
        })

      assert %{"token" => token} = json_response(conn, 201)
      assert is_binary(token)
      assert token != ""
      assert {:ok, authenticated_user} = Accounts.get_user_by_token(token)
      assert authenticated_user.id == admin.id
    end

    test "returns unauthorized for invalid credentials", %{conn: conn} do
      conn =
        post(conn, ~p"/api/sessions", %{
          "email" => "nobody@example.com",
          "password" => "wrongpassword"
        })

      assert %{"error" => "Invalid credentials"} = json_response(conn, 401)
    end

    test "returns forbidden for valid non-admin credentials", %{conn: conn} do
      user_fixture(%{email: "user@example.com", password: "supersecret"})

      conn =
        post(conn, ~p"/api/sessions", %{
          "email" => "user@example.com",
          "password" => "supersecret"
        })

      assert %{"error" => "Insufficient permissions"} = json_response(conn, 403)
    end
  end

  describe "delete/2" do
    test "logs out successfully with a bearer token", %{conn: conn} do
      admin = admin_user_fixture(%{})
      {:ok, token} = Accounts.create_token(admin)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token.token}")
        |> delete(~p"/api/sessions")

      assert %{"message" => "Logged out successfully"} = json_response(conn, 200)
      assert {:error, :unauthorized} = Accounts.get_user_by_token(token.token)
    end
  end

  defp admin_user_fixture(attrs) do
    valid_attrs = %{
      email: "admin#{System.unique_integer([:positive])}@example.com",
      password: "supersecret",
      role: :admin
    }

    {:ok, admin} =
      valid_attrs
      |> Map.merge(attrs)
      |> Accounts.create_user()

    admin
  end

  defp user_fixture(attrs) do
    valid_attrs = %{
      email: "user#{System.unique_integer([:positive])}@example.com",
      password: "supersecret",
      role: :user
    }

    {:ok, user} =
      valid_attrs
      |> Map.merge(attrs)
      |> Accounts.create_user()

    user
  end
end
