defmodule GameStore.Accounts.Token do
  use Ecto.Schema

  schema "tokens" do
    field :token, :string

    belongs_to :user, GameStore.Accounts.User

    timestamps(type: :utc_datetime)
  end
end
