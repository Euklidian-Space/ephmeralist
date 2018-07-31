defmodule Ephemeralist.UserControllerTest do 
  use EphemeralistWeb.ConnCase
  alias Ephemeralist.{Accounts, Repo, Guardian}
  alias Accounts.User
  @create_attrs %{
    name: "some name", 
    username: "some_username",
    credential: %{
      email: "some_email@example.com",
      password: "Password1234"
    }
  }
  @invalid_user_attrs %{name: nil, username: nil}

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
    setup [:register_user]

    test "Responds with user info if user is found", 
    %{conn: conn, user: user, token: token} 
    do 
      response = 
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get(user_path(conn, :show, user.id))
        |> json_response(200)

      expected = %{
        "data" => %{ "name" => user.name, "username" => user.username }
      }

      assert response == expected
    end 
  
    test "responds with a message indicating user not found", 
    %{conn: conn, token: token} 
    do 
      invalid_id = 1_000
      response = 
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get(user_path(conn, :show, invalid_id))
        |> json_response(404)

      expected = %{"errors" => %{"detail" => "user not found"}}

      assert response == expected
    end

    test "responds with a message if there is no token in the header",
    %{conn: conn} 
    do 
      response = 
        conn 
        |> get(user_path(conn, :show, 1))
        |> json_response(401)

      expected = %{"errors" => %{"detail" => "unauthenticated"}}

      assert response == expected
    end 
  end 

  describe "create/2" do 
    test "should respond with user info and credentials if creation was successful",
    %{conn: conn}
    do 
      response = 
        conn
        |> post(user_path(conn, :create, @create_attrs))
        |> json_response(200)

      %User{id: expected_id} = 
        Repo.get_by(User, username: @create_attrs.username)

      expected_type = "refresh"
      expected_lifespan = "4 weeks"

      {:ok, 
        %User{id: received_id}, 
        %{"typ" => received_type, "lifespan" => received_lifespan}
      } = 
        Guardian.resource_from_token(response["token"])

      assert received_lifespan == expected_lifespan 
      assert received_type == expected_type
      assert received_id == expected_id
    end 

    test "responds with error message for invalid user info", 
    %{conn: conn}
    do 
      response = 
        conn 
        |> post(user_path(conn, :create, @invalid_user_attrs))
        |> json_response(422)
      
      expected = %{
        "errors" => %{
          "name" => ["can't be blank"],
          "username" => ["can't be blank"],
          "credential" => ["can't be blank"]
        }
      }

      assert response == expected
    end 
  end

  describe "sign_in/2" do 
    setup [:register_user]

    test "should respond with auth token", 
    %{conn: conn, user: user} 
    do 
      response = 
        conn
        |> post(user_path(conn, :sign_in, @create_attrs.credential))
        |> json_response(200)

      expected_email = user.credential.email
      expected_username = user.username
      expected_id = user.id
      
      assert %{
        "token" => token, 
        "email" => ^expected_email, 
        "username" => ^expected_username
      } = response["data"]

      assert {:ok, %User{id: ^expected_id}, _} = 
        Guardian.resource_from_token(token)
    end 

    test "should respond with error for incorrect password", 
    %{conn: conn} 
    do 
      invalid_attrs = 
        Map.put(@create_attrs.credential, :password, "wrong password")

      response = 
        conn 
        |> post(user_path(conn, :sign_in, invalid_attrs))
        |> json_response(400)

      expected = %{
        "errors" => %{"detail" => "invalid email or password"} 
      }

      assert response == expected
    end 

    test "should respond with error for unknown email", 
    %{conn: conn} 
    do 
      invalid_attrs = 
        Map.put(@create_attrs.credential, :email, "wrong_email@ex.com")

      response = 
        conn 
        |> post(user_path(conn, :sign_in, invalid_attrs))
        |> json_response(404)

      expected = %{
        "errors" => %{"detail" => "user not found"}
      } 

      assert response == expected
    end 
  end 

  # defp create_user(_) do 
  #   {:ok, user} = Accounts.create_user(@create_attrs)

  #   {:ok, user: user}
  # end 

  defp register_user(_) do 
    {:ok, user, token} = Accounts.register_user(@create_attrs)
    {:ok, user: Ephemeralist.Repo.preload(user, :credential), token: token}
  end 
  
end 





