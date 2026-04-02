defmodule GameStore.AccountsTest do
  use GameStore.DataCase

  alias GameStore.Accounts
  alias GameStore.Accounts.Token

  describe "create_user/1" do
    test "normalizes email and stores the role as an enum" do
      assert {:ok, user} =
               Accounts.create_user(%{
                 email: "ADMIN@Example.COM",
                 password: "supersecret",
                 role: "admin"
               })

      assert user.email == "admin@example.com"
      assert user.role == :admin
      assert user.password == nil
      assert is_binary(user.password_hash)
    end
  end

  describe "authenticate_user/2" do
    test "authenticates a user with mixed-case email input" do
      user = user_fixture(%{email: "admin@example.com", password: "supersecret", role: :admin})

      assert {:ok, authenticated_user} =
               Accounts.authenticate_user("ADMIN@EXAMPLE.COM", "supersecret")

      assert authenticated_user.id == user.id
    end

    test "returns invalid credentials for wrong password" do
      user_fixture(%{email: "admin@example.com", password: "supersecret", role: :admin})

      assert {:error, :invalid_credentials} =
               Accounts.authenticate_user("admin@example.com", "wrongpassword")
    end
  end

  describe "get_user_by_token/1" do
    test "returns the admin user for a valid token" do
      user = user_fixture(%{role: :admin})
      {:ok, token} = Accounts.create_token(user)

      assert {:ok, found_user} = Accounts.get_user_by_token(token.token)
      assert found_user.id == user.id
    end

    test "rejects non-admin users" do
      user = user_fixture(%{role: :user})
      {:ok, token} = Accounts.create_token(user)

      assert {:error, :unauthorized} = Accounts.get_user_by_token(token.token)
    end
  end

  describe "delete_token/1" do
    test "deletes an existing token" do
      user = user_fixture(%{role: :admin})
      {:ok, token} = Accounts.create_token(user)

      assert {:ok, %Token{}} = Accounts.delete_token(token.token)
      assert {:error, :unauthorized} = Accounts.get_user_by_token(token.token)
    end
  end

  describe "update_user_role/3" do
    test "updates a user's role successfully" do
      admin = user_fixture(%{role: :admin})
      user = user_fixture(%{role: :user})

      assert {:ok, updated_user} = Accounts.update_user_role(user.id, "admin", admin)
      assert updated_user.role == :admin
    end

    test "returns not found when updating a missing user" do
      admin = user_fixture(%{role: :admin})

      assert {:error, :not_found} = Accounts.update_user_role(999999, "admin", admin)
    end

    test "prevents an admin from demoting themselves" do
      admin = user_fixture(%{role: :admin})

      assert {:error, :cannot_demote_self} = Accounts.update_user_role(admin.id, "user", admin)
    end
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
