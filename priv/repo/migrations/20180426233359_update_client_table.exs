defmodule CreditApp.Repo.Migrations.UpdateClientTable do
  use Ecto.Migration

  def change do
    alter table(:clients) do
      modify :credit, :float
    end
  end
end
