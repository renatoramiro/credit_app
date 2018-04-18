defmodule CreditApp.UserTest do
  use CreditApp.DataCase

  alias CreditApp.User

  @valid_attrs %{enabled: true, identity_document: "123456", phone: "83911112222"}
  @valid_registration_attrs %{enabled: true, identity_document: "123456", phone: "83911112222", password: "123456"}

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "registration changeset with valid attributes" do
    changeset = User.registration_changeset(%User{}, @valid_registration_attrs)
    assert changeset.valid?
  end

  test "registration changeset with invalid attributes" do
    changeset = User.registration_changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "password_hash in registration changeset with valid attributes" do
    changeset = User.registration_changeset(%User{}, @valid_registration_attrs)
    assert Comeonin.Bcrypt.checkpw(@valid_registration_attrs.password, changeset.changes.password_hash)
  end

  test "password in registration changeset when length is less than 6" do
    changeset = User.registration_changeset(%User{}, Map.replace!(@valid_registration_attrs, :password, "12345"))
    refute changeset.valid?
  end

end
