defmodule Ephemeralist.Accounts.Credential do 
  use Ecto.Schema 
  import Ecto.Changeset
  alias __MODULE__

  schema "credentials" do 
    field :email, :string 
    field :password, :string, virtual: true 
    field :password_hash, :string 
    belongs_to :user, Ephemeralist.Accounts.User

    timestamps()
  end 

  @doc false
  def changeset(%Credential{} = credential, attrs) do 
    credential
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email)
    |> put_pass_hash
  end 

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: changes} = cs) do 
    hash_pw = Comeonin.Bcrypt.hashpwsalt(changes.password)
    put_change(cs, :password_hash, hash_pw)
  end 

  defp put_pass_hash(cs), do: cs
end 
