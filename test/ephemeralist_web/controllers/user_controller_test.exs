defmodule Ephemeralist.UserControllerTest do 
  use EphemeralistWeb.ConnCase
  alias Ephemeralist.Accounts
  alias EphemeralistWeb.UserController
  @create_attrs %{name: "some name", username: "some_username"}

  test "index/2 responds with all users", %{conn: conn} do 
    users = [%{name: "some name", username: "some user name"},
             %{name: "some other name", username: "some other username"}]

    [{:ok, user1}, {:ok, user2}] =
      Enum.map(users, fn u -> Accounts.create_user(u) end)

    response =
      conn
      |> get(user_path(conn, :index))
      |> json_response(200)

    expected = %{
      "data" => [
        %{"name" => user1.name, "username" => user1.username},
        %{"name" => user2.name, "username" => user2.username}
      ]
    }

    assert response == expected
  end 

  describe "show/2" do 
    setup [:create_user]
    test "Responds with user info if user is found", 
    %{conn: conn, user: user} 
    do 
      response = 
        conn
        |> get(user_path(conn, :show, user.id))
        |> json_response(200)

      expected = %{
        "data" => %{ "name" => user.name, "username" => user.username }
      }

      assert response == expected
    end 
    
    test "responds with a message indicating user not found", 
    %{conn: conn} 
    do 
      invalid_id = 1_000
      response = 
        conn
        |> get(user_path(conn, :show, invalid_id))
        |> json_response(404)

      expected = %{"errors" => %{"detail" => "user not found"}}

      assert response == expected
    end
  end 

  defp create_user(_) do 
    {:ok, user} = Accounts.create_user(@create_attrs)

    {:ok, user: user}
  end 
  
end 





