defmodule EphemeralistWeb.UserController do 
  use EphemeralistWeb, :controller
  alias Ephemeralist.{Accounts, Guardian}
  @token_lifespan "4 weeks"

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
         {:ok, token, _} <- registration_token(user)
    do 
      render(conn, "userToken.json", token: token)
    end 
  end 

  defp registration_token(user) do 
    Guardian.encode_and_sign(
      user, %{"lifespan" => @token_lifespan}, 
      token_type: "refresh", 
      ttl: {4, :weeks}
    )
  end 
end 
