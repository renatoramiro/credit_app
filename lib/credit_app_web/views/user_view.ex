defmodule CreditAppWeb.UserView do
  use CreditAppWeb, :view

  def render("activation_code.json", %{user: user}) do
    %{data: render_one(user, CreditAppWeb.UserView, "activate_user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, CreditAppWeb.UserView, "user.json")}
  end

  def render("activate_user.json", %{user: user}) do
    %{
      id: user.id,
      phone: user.phone,
      activation_code: "123456"
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      phone: user.phone,
      enabled: user.enabled,
      identity_document: user.identity_document
    }
  end
end
