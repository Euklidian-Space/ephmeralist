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
    Repo.get User, id 
  end 

  def get_user!(id) do 
    Repo.get! User, id
  end 
end 
