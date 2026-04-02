defmodule GameStore.Accounts do
  @moduledoc """
  The accounts context for users, roles, and API authentication tokens.
  """

  alias GameStore.Repo
  alias GameStore.Accounts.User
  alias GameStore.Accounts.Token

  @doc """
  Creates a new user account.

  Expects a map of user registration attributes.
  Returns `{:ok, %User{}}` on success or `{:error, %Ecto.Changeset{}}` on failure.
  """
  def create_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
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
    case Repo.get_by(User, email: String.downcase(email)) do
      nil ->
        Bcrypt.no_user_verify()
        {:error, :invalid_credentials}

      %User{} = user ->
        if Bcrypt.verify_pass(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  @doc """
  Fetches a user by id.

  Expects a user id.
  Returns a `%User{}` struct or `nil` when no user exists for that id.
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
  def create_token(%User{} = user) do
    token_value = :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)

    %Token{}
    |> Token.changeset(%{token: token_value, user_id: user.id})
    |> Repo.insert()
  end

  def get_user_by_token(nil), do: {:error, :unauthorized}

  @doc """
  Looks up a token and returns the associated admin user.

  Expects a token string or `nil`.
  This runs on every authenticated API request.
  Returns `{:ok, %User{}}` if the token exists and belongs to an admin,
  or `{:error, :unauthorized}` otherwise.
  """
  def get_user_by_token(token_value) do
    case Repo.get_by(Token, token: token_value) do
      nil ->
        {:error, :unauthorized}

      %Token{} = token ->
        case Repo.preload(token, :user) do
          %Token{user: %User{role: :admin} = user} ->
            {:ok, user}

          %Token{} ->
            {:error, :unauthorized}
        end
    end
  end

  @doc """
  Deletes an API token if it exists.

  Expects a token string.
  Returns `:ok` when no token exists, `{:ok, %Token{}}` when deletion succeeds,
  or `{:error, %Ecto.Changeset{}}` if deletion fails.
  """
  def delete_token(token_value) do
    case Repo.get_by(Token, token: token_value) do
      nil ->
        :ok

      %Token{} = token ->
        Repo.delete(token)
    end
  end

  @doc """
  Lists all users.

  Expects no arguments.
  Returns a list of `%User{}` structs.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Updates a user's role while preventing an admin from demoting themselves.

  Expects a user id, a role value, and the current `%User{}` performing the action.
  Returns `{:ok, %User{}}`, `{:error, :not_found}`, or `{:error, reason}`.
  """
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
    if user.id == current_user.id and current_user.role == :admin and role in [:user, "user"] do
      {:error, :cannot_demote_self}
    else
      :ok
    end
  end
end
