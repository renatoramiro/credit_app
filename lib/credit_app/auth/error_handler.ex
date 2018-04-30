defmodule CreditApp.Auth.ErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    body = Poison.encode!(%{message: "Not authorized!", type: type})
    send_resp(conn, 401, body)
  end
end
