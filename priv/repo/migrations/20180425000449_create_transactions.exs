defmodule CreditApp.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :value, :decimal
      add :client_id, references(:clients, on_delete: :nothing)
      add :transaction_id, references(:clients, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:client_id])
    create index(:transactions, [:transaction_id])
  end
end
