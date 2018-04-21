defmodule CreditAppWeb.SessionView do
  use CreditAppWeb, :view

  def render("login.json", %{user: user}) do
    %{
      data: %{
        id: user.client.id,
        user_id: user.id,
        name: user.client.name,
        agency: user.client.agency,
        account: user.client.account,
        credit: user.client.credit,
        identity_document: user.identity_document,
        phone: user.phone,
        address: user.client.address
      }
    }
  end

  def render("logout.json", %{}) do
    %{message: "Successful signed out."}
  end
end