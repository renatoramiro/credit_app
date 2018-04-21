defmodule CreditAppWeb.ClientController do
  use CreditAppWeb, :controller

  alias CreditApp.{Client, Repo}

  def create(conn, %{"client" => client_params}) do
    changeset = Client.creation_changeset(%Client{}, client_params)

    case Repo.insert(changeset) do
      {:ok, client} ->
        render(conn, "show.json", client: client)
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render(CreditAppWeb.ErrorView, "400.json", changeset: changeset)
    end
  end
end