defmodule CreditApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :phone, :string
      add :identity_document, :string
      add :password_hash, :string
      add :enabled, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, [:phone])
    create unique_index(:users, [:identity_document])
  end
end
