defmodule GameStore.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string, null: false

      timestamps(type: :utc_datetime)
    end

    # Enforce unique emails at the database level.
    # This means two accounts with the same email
    # can never exist even under concurrent inserts.
    create unique_index(:users, [:email])
  end
end
