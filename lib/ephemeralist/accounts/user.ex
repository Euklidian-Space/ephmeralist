defmodule Ephemeralist.Accounts.User do 
  use Ecto.Schema 
  import Ecto.Changeset
  alias Ephemeralist.Accounts.{User, Credential}

  schema "users" do 
    field :name, :string 
    field :username, :string 
    has_one :credential, Credential

    timestamps()
  end 

  def changeset(%User{} = user, attrs) do 
    user 
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> unique_constraint(:username) 
    |> validate_length(:username, min: 4, max: 20)
  end 

  def registration_changeset(%User{} = user, attrs) do 
    user 
    |> changeset(attrs)
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end 
end 
