defmodule GameStore.Repo.Migrations.FixCoverImageAndPlatform do
  use Ecto.Migration

  def change do
    alter table(:games) do
      modify :cover_image, :text
    end
  end
end
