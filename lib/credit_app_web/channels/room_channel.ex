defmodule CreditAppWeb.RoomChannel do
  use CreditAppWeb, :channel

  def join("room:lobby", _payload, socket) do
    {:ok, socket}
  end

  def join("room:" <> user_id, _params, socket) do
    {:ok, assign(socket, :user, user_id)}
  end

  def terminate(_reason, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  # def handle_in("ping", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end

  def handle_in("reload_client:msg", %{"body" => body}, socket) do
    CreditAppWeb.Endpoint.broadcast!("room:#{body["id"]}", "reload_client:success:#{body["id"]}", %{"body" => body})
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("transaction:msg", %{"body" => body}, socket) do
    CreditAppWeb.Endpoint.broadcast!("room:#{body["id"]}", "transaction:success:#{body["id"]}", %{"body" => body})
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  # defp authorized?(_payload) do
  #   true
  # end
end
