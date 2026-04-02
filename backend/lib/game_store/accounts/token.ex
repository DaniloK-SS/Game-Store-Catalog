defmodule GameStore.Accounts.Token do
  @moduledoc """
  Ecto schema representing an API authentication token issued to a user.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :token, :string

    belongs_to :user, GameStore.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a changeset for creating or updating a token record.

  Expects a `%Token{}` struct and a map with `:token` and `:user_id`.
  Returns an `Ecto.Changeset`.
  """
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :user_id])
    |> validate_required([:token, :user_id])
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:token)
  end
end
