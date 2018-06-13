defmodule CreditApp.Repo.Migrations.AddPlayerIdUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :player_id, :string
    end
  end
end
