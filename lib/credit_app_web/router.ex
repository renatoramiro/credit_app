defmodule CreditAppWeb.Router do
  use CreditAppWeb, :router

  pipeline :api do
    plug :accepts, [:v1]
    plug CreditAppWeb.Version
  end

  pipeline :api_auth do
    plug Guardian.Plug.Pipeline, module: CreditApp.Auth.Guardian,
                             error_handler: CreditApp.Auth.ErrorHandler
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :set_token do
    plug CreditApp.Auth.Pipeline
  end

  scope "/api", CreditAppWeb do
    pipe_through :api

    post("/signup", RegistrationController, :create)
    post("/activateuser", RegistrationController, :activate_user)
    post("/signin", SessionController, :create)
  end

  scope "/api", CreditAppWeb do
    pipe_through [:api, :api_auth, :set_token]

    resources("/clients", ClientController, only: [:create, :update, :show])
    get("/listcredits", TransactionController, :index)
    post("/sendcredit", TransactionController, :send_credit)
    post("/getclient", ClientController, :get_client)
    get("/getclientbytoken", ClientController, :get_client_by_token)
  end
end
