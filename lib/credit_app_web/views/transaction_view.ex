defmodule CreditAppWeb.TransactionView do
  use CreditAppWeb, :view

  def render("successful.json", %{}) do
    %{message: "Successful transfer."}
  end
end