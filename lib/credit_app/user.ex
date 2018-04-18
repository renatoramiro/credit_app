defmodule CreditApp.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :enabled, :boolean, default: false
    field :identity_document, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :phone, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:phone, :identity_document, :password_hash, :enabled])
    |> validate_required([:phone, :identity_document, :enabled])
    |> unique_constraint(:phone)
    |> unique_constraint(:identity_document)
  end

  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, [:password], [])
    |> validate_length(:password, min: 6, max: 100)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case changeset  do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
