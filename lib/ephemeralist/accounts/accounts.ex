defmodule Ephemeralist.Accounts do 
  alias Ephemeralist.Accounts.User   
  alias Ephemeralist.Repo 
  #import Ecto.Query

  def create_user(attrs \\ %{}) do 
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert
  end 

  def list_users do 
    Repo.all User
  end 

  def get_user(id) do 
    case Repo.get(User, id) do 
      nil -> {:error, :user_not_found}

      user -> {:ok, user}
    end 
  end 

  def get_user!(id) do 
    {:ok, Repo.get!(User, id)}
  end 
end 
