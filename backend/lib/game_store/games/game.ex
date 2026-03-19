defmodule GameStore.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :title, :string
    field :genre, :string
    field :platform, :string
    field :price, :decimal
    field :release_year, :integer
    field :publisher, :string
    field :cover_image, :string
    field :description, :string
    field :in_stock, :boolean, default: false
    field :featured, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
  game
  |> cast(attrs, [
    :title, :genre, :platform, :price,
    :release_year, :publisher, :cover_image,
    :description, :in_stock, :featured
  ])
  |> validate_required([
    :title, :genre, :platform, :price,
    :release_year, :publisher
  ])
end
end
