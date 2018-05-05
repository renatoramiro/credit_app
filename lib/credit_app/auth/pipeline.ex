defmodule CreditApp.Auth.Pipeline do
  import Plug.Conn

  def init(opts), do: opts
  def call(conn, _opts) do
    conn = conn
    |> put_resp_header("Authorization", "Bearer #{refresh_token(conn)}")
    conn
  end

  defp refresh_token(conn) do
    jwt = Guardian.Plug.current_token(conn)
    {:ok, _old_token, {new_token, _new_claim}} = CreditApp.Auth.Guardian.refresh(jwt)
    new_token
  end
end
