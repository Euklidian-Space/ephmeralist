defmodule EphemeralistWeb.UserController do 
  use EphemeralistWeb, :controller
  alias Ephemeralist.{Accounts, Guardian}

  action_fallback EphemeralistWeb.FallbackController

  def index(conn, _) do 
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end 

  def show(conn, %{"id" => id}) do 
    with {:ok, user} <- Accounts.get_user(id) do 
      render(conn, "show.json", user: user)
    end
  end 

  def create(conn, %{"name" => _, "username" => _} = params) do 
    with {:ok, _, token} <- Accounts.register_user(params) do 
      render(conn, "userToken.json", token: token)
    end 
  end 

  def sign_in(conn, %{"email" => email, "password" => password}) do 
    with {:ok, user, token} <- Accounts.token_sign_in(email, password) do 
      data = %{token: token, email: user.credential.email, username: user.username}
      render(conn, "user_and_token.json", data)
    end 
  end 

end 
