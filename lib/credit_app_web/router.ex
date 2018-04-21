defmodule CreditAppWeb.Router do
  use CreditAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.Pipeline, module: CreditApp.Auth.Guardian,
                             error_handler: CreditApp.Auth.ErrorHandler
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
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

    post("/createclient", ClientController, :create)
  end
end
