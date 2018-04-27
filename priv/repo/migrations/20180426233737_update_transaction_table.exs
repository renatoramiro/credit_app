defmodule CreditApp.Repo.Migrations.UpdateTransactionTable do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      modify :value, :float
    end
  end
end
