defmodule GameStore.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_hash, :string, redact: true
    field :password, :string, virtual: true, redact: true
    field :role, :string, default: "user"

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :role])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
    |> validate_length(:password, min: 8, message: "must be at least 8 characters")
    |> validate_inclusion(:role, ["user", "admin"], message: "must be user or admin")
    |> unique_constraint(:email, message: "already taken")
    |> hash_password()
  end

  def role_changeset(user, attrs) do
      user
      |> cast(attrs, [:role])
      |> validate_required([:role])
      |> validate_inclusion(:role, ["user", "admin"], message: "must be user or admin")
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
    end
  end
end
