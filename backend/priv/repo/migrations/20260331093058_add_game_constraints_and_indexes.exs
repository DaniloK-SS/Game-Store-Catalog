defmodule GameStore.Repo.Migrations.AddGameConstraintsAndIndexes do
  use Ecto.Migration

  def change do
    alter table(:games) do
      modify :title, :string, null: false
      modify :genre, :string, null: false
      modify :platform, :string, null: false
      modify :price, :decimal, null: false
      modify :release_year, :integer, null: false
      modify :publisher, :string, null: false
    end

    create index(:games, [:platform])
    create index(:games, [:genre])
    create index(:games, [:price])
    create index(:games, [:release_year])
    create index(:games, [:title])
  end
end
