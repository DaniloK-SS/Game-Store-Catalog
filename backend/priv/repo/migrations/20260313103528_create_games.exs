defmodule GameStore.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :title, :string
      add :genre, :string
      add :platform, :string
      add :price, :decimal
      add :release_year, :integer
      add :publisher, :string
      add :cover_image, :string
      add :description, :text
      add :in_stock, :boolean, default: false, null: false
      add :featured, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
