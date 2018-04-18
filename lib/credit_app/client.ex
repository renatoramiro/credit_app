defmodule CreditApp.Client do
  use Ecto.Schema
  import Ecto.Changeset


  schema "clients" do
    field :account, :string
    field :address, :string
    field :agency, :string
    field :credit, :decimal
    field :name, :string
    belongs_to(:user, CreditApp.User)

    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:name, :address, :agency, :account, :credit, :user_id])
    |> validate_required([:name, :address, :agency, :account, :credit, :user_id])
    |> unique_constraint(:account)
    |> assoc_constraint(:user)
  end
end
