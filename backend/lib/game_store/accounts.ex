defmodule GameStore.Accounts do
  alias GameStore.Repo
  alias GameStore.Accounts.User
  alias GameStore.Accounts.Token

  @doc """
  Creates a new user with a hashed password.
  Returns {:ok, user} on success, {:error, changeset} on failure.
  """
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Looks up a user by email and verifies their password.
  Returns {:ok, user} if credentials are valid.
  Returns {:error, :invalid_credentials} if email not found
  or password is wrong.

  We always run the password check even when the user is not
  found. This prevents timing attacks where an attacker could
  figure out which emails exist in the system by measuring
  how fast the response comes back.
  """
  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: String.downcase(email))

    case user do
      nil ->
        Bcrypt.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        if Bcrypt.verify_pass(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  @doc """
  Fetches a single user by ID.
  Returns the user or nil if not found.
  Used by the RequireAdmin plug to verify the session.
  """
  def get_user(id) do
    Repo.get(User, id)
  end

    @doc """
  Creates a token for the given user.
  Generates a random URL-safe string, stores it in the
  database linked to the user, and returns it.
  This token is what gets sent back to the client after login.
  """
  def create_token(user) do
    token_value = :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)

    %Token{}
    |> Ecto.Changeset.change(%{token: token_value, user_id: user.id})
    |> Repo.insert()
  end

  def get_user_by_token(nil), do: {:error, :unauthorized}

  @doc """
  Looks up a token and returns the associated user.
  This runs on every authenticated API request.
  Returns {:ok, user} if the token exists and the user is an admin.
  Returns {:error, :unauthorized} otherwise.
  """
  def get_user_by_token(token_value) do
    token = Repo.get_by(Token, token: token_value)

    case token do
      nil ->
        {:error, :unauthorized}

      token ->
        user = Repo.get(User, token.user_id)

        if user && user.role == "admin" do
          {:ok, user}
        else
          {:error, :unauthorized}
        end
    end
  end

  @doc """
  Deletes a token by its value.
  Called on logout — after this the token is gone
  and can never be used again.
  """
  def delete_token(token_value) do
    case Repo.get_by(Token, token: token_value) do
      nil -> :ok
      token -> Repo.delete(token)
                :ok
    end
  end

  def list_users do
    Repo.all(User)
  end

  def update_user_role(id, role, current_user) do
  with %User{} = user <- Repo.get(User, id),
       :ok <- prevent_self_demotion(user, role, current_user) do
    user
    |> User.role_changeset(%{role: role})
    |> Repo.update()
  else
    nil ->
      {:error, :not_found}

    {:error, _reason} = error ->
      error
  end
end

defp prevent_self_demotion(user, role, current_user) do
  if user.id == current_user.id and current_user.role == "admin" and role == "user" do
    {:error, :cannot_demote_self}
  else
    :ok
  end
end
end
