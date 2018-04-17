defmodule CreditAppWeb.Router do
  use CreditAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CreditAppWeb do
    pipe_through :api
  end
end
