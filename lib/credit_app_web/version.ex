defmodule CreditAppWeb.Version do
  @versions Application.get_env(:mime, :types)
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case length(get_req_header(conn, "accept")) == 0 do
      true ->
        _call(conn, [])
      false ->
        [accept] = get_req_header(conn, "accept")
        version = Map.fetch(@versions, accept)
        _call(conn, version)
    end
  end

  defp _call(conn, {:ok, [version]}) do
    assign(conn, :version, version)
  end
  defp _call(conn, _) do
    conn
    |> send_resp(404, "{\"errors\": {\"detail\": \"Version not found!\"}\"}")
    |> halt()
  end
end
