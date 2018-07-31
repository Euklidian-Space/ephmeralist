defmodule Ephemeralist.Accounts do 
  alias Ephemeralist.Accounts.User   
  alias Ephemeralist.{Repo, Guardian}
  import Ecto.Query

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

  def register_user(attrs \\ %{}) do 
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert
    |> case do 
      {:ok, user} -> 
        {:ok, token, _} = authorization_token(user)
        {:ok, user, token}
      err -> err
    end 
  end 


  def token_sign_in(email, password) 
  when is_binary(email) and is_binary(password)  
  do 
    case check_email_and_password(email, password) do 
      {:ok, user} -> 
        {:ok, token, _} = authorization_token(user)
        {:ok, user, token} 

      {:error, _msg} = err -> err
    end 
  end 

  defp authorization_token(user) do 
    token_lifespan = "4 weeks"
    Guardian.encode_and_sign(
      user, %{"lifespan" => token_lifespan}, 
      token_type: "refresh", 
      ttl: {4, :weeks}
    )
  end 

  defp check_email_and_password(email, password) do 
    user = get_user_by_email(email)
    cond do 
      user && 
        Comeonin.Bcrypt.checkpw(password, user.credential.password_hash) ->
          {:ok, user}

      user -> 
        {:error, :unauthorized}

      true -> 
        Comeonin.Bcrypt.dummy_checkpw()
        {:error, :user_not_found}
    end 
  end 

  defp get_user_by_email(email) do 
    email_query(email)
    |> Repo.one 
    |> Repo.preload(:credential)
  end 

  defp email_query(email) do 
    from(u in User, join: c in assoc(u, :credential), where: c.email == ^email)
  end 

end 
