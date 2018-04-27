defmodule CreditApp.Client do
  use Ecto.Schema
  import Ecto.{Changeset, Query}


  schema "clients" do
    field :account, :string
    field :address, :string
    field :agency, :string
    field :credit, :float
    field :name, :string

    belongs_to(:user, CreditApp.User)
    many_to_many :transactions, CreditApp.Client, join_through: "transactions",
      on_replace: :delete, join_keys: [client_id: :id, transaction_id: :id]
      
    many_to_many :reverse_transactions, CreditApp.Client, join_through: "transactions",
      on_replace: :delete, join_keys: [transaction_id: :id, client_id: :id]

    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:name, :address, :agency, :account, :credit, :user_id])
    |> validate_required([:name, :address, :user_id])
    |> unique_constraint(:account)
    |> assoc_constraint(:user)
  end

  @doc false
  def update_changeset(client, attrs) do
    client
    |> cast(attrs, [:name, :address])
    |> validate_required([:name, :address])
    |> unique_constraint(:account)
    |> assoc_constraint(:user)
  end

  @doc false
  def creation_changeset(struct, attrs) do
    struct
    |> changeset(attrs)
    |> set_agency()
    |> set_account()
    |> set_credit()
  end

  defp set_credit(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :credit, 10.1)
      _ ->
        changeset
    end
  end

  defp set_agency(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :agency, "00001")
      _ ->
        changeset
    end
  end

  defp set_account(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        case from(d in CreditApp.Client, limit: 1, order_by: [desc: d.inserted_at]) |> CreditApp.Repo.one do
          client = %CreditApp.Client{} ->
            last_account = get_last_account(client.account)
            length = get_length_last_account(client.account)
            put_change(changeset, :account, generate_account(last_account, length))
          nil ->
            put_change(changeset, :account, "000001")
        end
      _ ->
        changeset
    end
  end

  defp get_last_account(account) do
    account
    |> String.to_integer()
  end

  defp get_length_last_account(account) do
    account
    |> String.to_integer()
    |> Integer.to_string()
    |> String.length()
    |> Kernel.+(1)
  end

  defp generate_account(integer_last_account, string_length) do
    zeros = String.duplicate("0", 8 - string_length)
    "#{zeros}#{integer_last_account + 1}"
  end

end
