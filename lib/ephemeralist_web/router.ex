defmodule EphemeralistWeb.Router do
  use EphemeralistWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EphemeralistWeb do
    pipe_through :api
  end
end
