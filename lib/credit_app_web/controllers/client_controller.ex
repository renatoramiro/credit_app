defmodule CreditAppWeb.ClientController do
  use CreditAppWeb, :controller

  alias CreditApp.{Client, Repo}

  plug :scrub_params, "client" when action in [:create, :update]

  def create(%{assigns: %{version: :v1}}=conn, %{"client" => client_params}) do
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

  def update(%{assigns: %{version: :v1}}=conn, %{"id" => id, "client" => client_params}) do
    with client = %Client{} <- Repo.get(Client, id) do
      changeset = Client.update_changeset(client, client_params)
      case Repo.update(changeset) do
        {:ok, client} ->
          render(conn, "show_full.json", client: Repo.preload(client, [:user]))
        {:error, changeset} ->
          conn
          |> put_status(400)
          |> render(CreditAppWeb.ErrorView, "400.json", changeset: changeset)
      end
    else
      nil ->
        conn
        |> put_status(404)
        |> render(CreditAppWeb.ErrorView, "404.json", message: "Client not found!")
    end
  end

  def get_client_by_token(%{assigns: %{version: :v1}}=conn, _params) do
    resource = CreditApp.Auth.Guardian.Plug.current_resource(conn)
    client = Repo.get_by(Client, user_id: resource.id)

    case client do
      %Client{} ->
        CreditAppWeb.Endpoint.broadcast!("room:#{client.id}", "reload_client:msg", %{"reload_client" => true})
        render(conn, "show.json", client: client)
      _ ->
        conn
        |> put_status(404)
        |> render(CreditAppWeb.ErrorView, "404.json", message: "Client not found!")
    end
  end

  def get_client(%{assigns: %{version: :v1}}=conn, %{"account" => account, "agency" => agency}) do
    client = Repo.get_by(Client, %{agency: agency, account: account})
    case client do
      %Client{} ->
        render(conn, "get_client.json", client: client)
      nil ->
        conn
        |> put_status(404)
        |> render(CreditAppWeb.ErrorView, "404.json", message: "Client not found!")
    end
  end

  def show(%{assigns: %{version: :v1}}=conn, %{"id" => id}) do
    client = Repo.get(Client, id)
    case client do
      %Client{} ->
        render(conn, "get_client.json", client: client)
      nil ->
        conn
        |> put_status(404)
        |> render(CreditAppWeb.ErrorView, "404.json", message: "Client not found!")
    end
  end
end
