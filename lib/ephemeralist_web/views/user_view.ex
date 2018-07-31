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

  def render(
    "user_and_token.json", 
    %{token: token, email: email, username: uname}
    ) 
  do 
    %{data: 
      %{token: token, email: email, username: uname}
    }
  end 
  
end 
