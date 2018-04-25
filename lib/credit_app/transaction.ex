defmodule CreditApp.Transaction do
  use Ecto.Schema
  import Ecto.Changeset


  schema "transactions" do
    field :value, :decimal
    
    belongs_to(:client, CreditApp.Client)
    belongs_to(:transaction, CreditApp.Client)

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
