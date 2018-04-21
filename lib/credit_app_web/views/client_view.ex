defmodule CreditAppWeb.ClientView do
  use CreditAppWeb, :view

  def render("show.json", %{client: client}) do
    %{data: render_one(client, CreditAppWeb.ClientView, "client.json")}
  end

  def render("client.json", %{client: client}) do
    %{
      id: client.id,
      name: client.name,
      address: client.address,
      credit: client.credit,
      agency: client.agency,
      account: client.account,
      user_id: client.user_id
    }
  end
end