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
    with {:ok, user} <- Accounts.register_user(params),
         {:ok, token, _} <- Guardian.encode_and_sign(user)
    do 
      render(conn, "userToken.json", token: token)
    end 
  end 
end 
