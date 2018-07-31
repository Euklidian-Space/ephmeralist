defmodule EphemeralistWeb.FallbackController do 
  use EphemeralistWeb, :controller 

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do 
    conn
    |> put_status(:unprocessable_entity)
    |> render(EphemeralistWeb.ChangesetView, "error.json", changeset: changeset)
  end 

  def call(conn, {:error, :user_not_found}) do 
    conn
    |> put_status(404)
    |> assign(:error_msg, "user not found")
    |> render(EphemeralistWeb.ErrorView, :"404")
  end 

  def call(conn, {:error, :unauthorized}) do 
    conn 
    |> put_status(400)
    |> assign(:error_msg, "invalid email or password")
    |> render(EphemeralistWeb.ErrorView, :"400")
  end 

  def call(conn, err) do 
    conn 
    |> put_status(500)
    |> render(EphemeralistWeb.ErrorView, :"500")
  end 
end 
