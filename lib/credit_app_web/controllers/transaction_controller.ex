defmodule CreditAppWeb.TransactionController do
  use CreditAppWeb, :controller

  alias CreditApp.{Repo, Transaction}

  plug :scrub_params, "transaction" when action in [:send_credit]

  def send_credit(conn, %{"transaction" => transaction_params}) do
    changeset = Transaction.changeset(%Transaction{}, transaction_params)

    case Repo.insert(changeset) do
      {:ok, transaction} ->
        debit_credit(transaction.transaction_id, transaction.value)
        credit_value(transaction.client_id, transaction.value)
        render(conn, "successful.json", transaction: transaction)
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render(CreditAppWeb.ErrorView, "400.json", changeset: changeset)
    end
  end

  defp debit_credit(transaction_id, value) do
    client = Repo.get!(CreditApp.Client, transaction_id)
    client = Ecto.Changeset.change(client, credit: client.credit - value)
    Repo.update!(client)
  end

  defp credit_value(client_id, value) do
    client = Repo.get!(CreditApp.Client, client_id)
    client = Ecto.Changeset.change(client, credit: client.credit + value)
    Repo.update!(client)
  end
end