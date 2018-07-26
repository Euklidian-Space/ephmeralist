defmodule EphemeralistWeb.UserView do 
  use EphemeralistWeb, :view

  def render("index.json", %{users: users}) do 
    %{data: render_many(users, __MODULE__, "user.json")}
  end 

  def render("show.json", %{user: user}) do 
    %{data: render_one(user, __MODULE__, "user.json")}
  end 

  def render("user.json", %{user: user}) do 
    %{name: user.name, username: user.username}
  end 

  def render("userToken.json", %{token: token}), do: %{token: token}
  
end 
