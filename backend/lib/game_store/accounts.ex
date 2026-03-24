defmodule GameStore.Accounts do
  alias GameStore.Repo
  alias GameStore.Accounts.User

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
end
