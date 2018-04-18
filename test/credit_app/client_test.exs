defmodule CreditApp.ClientTest do
  use CreditApp.DataCase

  alias CreditApp.Client

  @valid_attrs %{account: "001001", agency: "001", address: "Address 01", credit: 10.0, name: "Client 001", user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Client.changeset(%Client{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Client.changeset(%Client{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset without user_id" do
    changeset = Client.changeset(%Client{}, Map.delete(@valid_attrs, :user_id))
    refute changeset.valid?
  end
end
