defmodule EphemeralistWeb.Router do
  use EphemeralistWeb, :router
  alias Ephemeralist.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do 
    plug Guardian.AuthPipeline
  end 

  scope "/api", EphemeralistWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit, :show]
    post "/sign_in", UserController, :sign_in
  end

  scope "/api", EphemeralistWeb do 
    pipe_through [:api, :jwt_authenticated]

    get "/users/:id", UserController, :show
  end 
end
