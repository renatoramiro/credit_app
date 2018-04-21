defmodule CreditApp.Transation do
  use Ecto.Schema
  import Ecto.Changeset


  schema "transactions" do
    field :value, :decimal
    # field :source_id, :id
    # field :destiny_id, :id
    belongs_to(:source, CreditApp.Client)
    belongs_to(:destiny, CreditApp.Client)

    timestamps()
  end

  @doc false
  def changeset(transation, attrs) do
    transation
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
