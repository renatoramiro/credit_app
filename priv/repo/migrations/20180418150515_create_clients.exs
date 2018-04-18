defmodule CreditApp.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :name, :string
      add :address, :string
      add :agency, :string
      add :account, :string
      add :credit, :decimal
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:clients, [:account])
    create index(:clients, [:user_id])
  end
end
