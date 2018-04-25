defmodule CreditApp.Auth.ErrorHandler do
  import Plug.Conn

  def auth_error(conn, {_type, _reason}, _opts) do
    body = Poison.encode!(%{message: "Unauthorized!"})
    send_resp(conn, 401, body)
  end
end
