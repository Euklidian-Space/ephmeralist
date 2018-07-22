defmodule EphemeralistWeb.FallbackController do 
  use EphemeralistWeb, :controller 

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do 
    conn
    |> put_status(:unprocessable_entity)
    |> render(EphemeralistWeb.ChangesetView, "error.json", changeset: changeset)
  end 

  def call(conn, _) do 
    conn
    |> put_status(404)
    |> assign(:error_msg, "user not found")
    |> render(EphemeralistWeb.ErrorView, :"404")
  end 
end 
