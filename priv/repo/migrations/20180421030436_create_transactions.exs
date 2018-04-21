defmodule CreditApp.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :value, :decimal
      add :source_id, references(:clients, on_delete: :nothing)
      add :destiny_id, references(:clients, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:source_id])
    create index(:transactions, [:destiny_id])
  end
end
