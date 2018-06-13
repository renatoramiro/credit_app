defmodule CreditAppWeb.SessionController do
  use CreditAppWeb, :controller

  import Ecto.Query, only: [from: 2]
  import Comeonin.Bcrypt, only: [checkpw: 2]
  plug :scrub_params, "session" when action in [:create]

  alias CreditApp.{User, Repo}

  def create(%{assigns: %{version: :v1}}=conn, %{"session" => %{"identity_document" => identity_document, "password" => password, "player_id" => player_id}}) do
    query = from user in User,
      left_join: client in assoc(user, :client),
      preload: [client: client],
      where: user.id == client.user_id and user.identity_document == ^identity_document

    user = query_user(query, player_id)

    result = cond do
      user && checkpw(password, user.password_hash) && user.enabled == true && user.client != nil ->
        new_conn = login(conn, user)
        {:ok, new_conn, get_token(new_conn), get_expiration(new_conn)}
      user && user.enabled == false ->
        {:not_activated, conn}
      user && user.client == nil ->
        new_conn = login(conn, user)
        {:client_not_created, new_conn, get_token(new_conn), get_expiration(new_conn)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        {:error, :not_found, conn}
    end

    case result do
      {:ok, new_conn, jwt, exp_token} ->
        new_conn
        |> put_resp_header("Authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", to_string(exp_token))
        |> render("login.json", user: Repo.preload(user, [:client]))
      {:not_activated, conn} ->
        conn
        |> put_status(412)
        |> send_resp(:precondition_failed, "{\"message\": \"User was not activated.\", \"id\":#{user.id}, \"condition\": \"not_activated\"}")
        |> halt()
      {:client_not_created, new_conn, jwt, exp_token} ->
        new_conn
        |> put_status(412)
        |> put_resp_header("Authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", to_string(exp_token))
        |> send_resp(:precondition_failed, "{\"message\": \"Client was not created.\", \"id\":#{user.id}, \"condition\": \"client_not_created\"}")
        |> halt()
      {:error, reason, conn} ->
        conn
        |> send_resp(reason, "{\"message\": \"User was not found with these credentials.\"}")
        |> halt()
    end
  end

  defp query_user(query, player_id) do
    with user = %User{} <- Repo.one(query) do
      if user.player_id != player_id do
        changeset = Ecto.Changeset.change(user, player_id: player_id)
        case Repo.update(changeset) do
          {:ok, user} ->
            user
          {:error, _changeset} ->
            nil
        end
      else
        user
      end
    else
      nil ->
        nil
    end
  end

  defp login(conn, user) do
    conn
    |> CreditApp.Auth.Guardian.Plug.sign_in(user)
  end

  def delete(conn, opts) do
    conn
    |> logout()
    |> render("logout.json", opts)
  end

  defp get_token(conn) do
    Guardian.Plug.current_token(conn)
  end

  defp get_expiration(conn) do
    exp = Guardian.Plug.current_claims(conn)
    |> Map.get("exp")
    exp
  end

  defp logout(conn) do
    jwt = Guardian.Plug.current_token(conn)
    case CreditApp.Auth.Guardian.revoke(jwt) do
      {:ok, _claims} ->
        conn
      {:error, _any} ->
        halt(conn)
    end
  end
end
