defmodule CreditAppWeb.TransactionView do
  use CreditAppWeb, :view

  def render("successful.json", %{}) do
    %{message: "Successful transfer."}
  end

  def render("transactions.json", %{transactions: transactions, id: id}) do
    %{data: render_many(transactions, CreditAppWeb.TransactionView, "transaction.json"), current_user: id}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      client_id: transaction.client_id,
      transaction_id: transaction.transaction_id,
      value: transaction.value,
      inserted_at: transaction.inserted_at
    }
  end
end
