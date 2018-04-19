defmodule CreditAppWeb.RegistrationController do
  use CreditAppWeb, :controller

  alias CreditApp.{User, Repo}

  plug :scrub_params, "user" when action in [:create]

  def create(conn, %{"user" => user_params}) do
    changeset = %User{} |> User.registration_changeset(user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(CreditAppWeb.UserView, "activation_code.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(CreditAppWeb.ErrorView, "422.json", changeset: changeset)
    end
  end

  def activate_user(conn, %{"id" => id, "activation_code" => activation_code}) do
    with user = %User{} <- Repo.get(User, id) do
      case {activation_code, user.enabled} do
        {"123456", false} ->
          user = enable_user(user)
          conn
          |> put_status(:ok)
          |> render(CreditAppWeb.UserView, "show.json", user: user)
        _ ->
          conn
          |> put_status(:bad_request)
          |> render(CreditAppWeb.ErrorView, "404.json", message: "Wrong pin or already enabled!")
      end
    else
      nil ->
        conn
        |> put_status(404)
        |> render(CreditAppWeb.ErrorView, "404.json", message: "User not found!")
    end
  end

  defp enable_user(user) do
    user = Ecto.Changeset.change(user, enabled: true)
    user = Repo.update!(user)
    user
  end
end
