defmodule GameStore.Accounts.User do
  @moduledoc """
  Ecto schema representing an application user and their authorization role.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_hash, :string, redact: true
    field :password, :string, virtual: true, redact: true
    field :role, Ecto.Enum, values: [:user, :admin], default: :user

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a registration changeset for a new user.

  Expects a `%User{}` struct and a map containing at least `:email` and `:password`.
  Returns an `Ecto.Changeset` with normalized email, hashed password, and validations.
  """
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :role])
    |> validate_required([:email, :password])
    |> normalize_email()
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
    |> validate_length(:password, min: 8, message: "must be at least 8 characters")
    |> unique_constraint(:email, message: "already taken")
    |> hash_password()
  end

  @doc """
  Builds a changeset for updating user fields that do not require password changes.

  Expects a `%User{}` struct and a map of user attributes.
  Returns an `Ecto.Changeset`.
  """
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> normalize_email()
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
    |> unique_constraint(:email, message: "already taken")
  end

  @doc """
  Builds a changeset for changing a user's role.

  Expects a `%User{}` struct and a map containing `:role`.
  Returns an `Ecto.Changeset`.
  """
  def role_changeset(user, attrs) do
    user
    |> cast(attrs, [:role])
    |> validate_required([:role])
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      password ->
        changeset
        |> put_change(:password_hash, Bcrypt.hash_pwd_salt(password))
        |> delete_change(:password)
    end
  end

  defp normalize_email(changeset) do
    update_change(changeset, :email, &String.downcase/1)
  end
end
