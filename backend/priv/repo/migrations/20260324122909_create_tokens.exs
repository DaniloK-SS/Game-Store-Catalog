defmodule GameStore.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tokens, [:token])

    create index(:tokens, [:user_id])
  end
end
