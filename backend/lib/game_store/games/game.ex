defmodule GameStore.Games.Game do
  @moduledoc """
  Ecto schema representing a game listed in the store catalog.
  """

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

  @doc """
  Builds a changeset for creating or updating a game.

  Expects a `%Game{}` struct and a map of attributes.
  Returns an `Ecto.Changeset` with casting and validation errors applied.
  """
  def changeset(game, attrs) do
    game
    |> cast(attrs, [
      :title,
      :genre,
      :platform,
      :price,
      :release_year,
      :publisher,
      :cover_image,
      :description,
      :in_stock,
      :featured
    ])
    |> validate_required([
      :title,
      :genre,
      :platform,
      :price,
      :release_year,
      :publisher
    ])
    |> validate_length(:title, max: 255)
    |> validate_number(:price, greater_than: 0)
    |> validate_number(:release_year, greater_than: 1950, less_than: 2030)
  end
end
