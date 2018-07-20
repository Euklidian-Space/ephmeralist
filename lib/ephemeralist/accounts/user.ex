defmodule Ephemeralist.Accounts.User do 
  use Ecto.Schema 
  import Ecto.Changeset
  alias Ephemeralist.Accounts.User

  schema "users" do 
    field :name, :string 
    field :username, :string 

    timestamps()
  end 

  def changeset(%User{} = user, attrs) do 
    user 
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 4, max: 20)
  end 
end 
