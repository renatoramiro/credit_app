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
    |> cast(attrs, [:value, :client_id, :transaction_id])
    |> validate_required([:value, :client_id, :transaction_id])
    |> validate_client_transaction_exists(:transaction_id)
    |> validate_client_exists(:client_id)
  end

  @doc """
  Check if client exists and check if credits are sufficient
  """
  def validate_client_exists(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, client_id ->
      case CreditApp.Repo.get(CreditApp.Client, client_id) do
        client = %CreditApp.Client{} ->
          unless client.credit > changeset.changes.value do
            [{:value, options[:message] || "Insufficient credits!"}]
          else
            []
          end
        nil ->
          [{field, options[:message] || "Client not found!"}]
      end
    end)
  end

  @doc """
  Check if client exists
  """
  def validate_client_transaction_exists(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, client_id ->
      case CreditApp.Repo.get(CreditApp.Client, client_id) do
        _client = %CreditApp.Client{} ->
          []
        nil ->
          [{:transaction_id, options[:message] || "Client not found!"}]
      end
    end)
  end
end
