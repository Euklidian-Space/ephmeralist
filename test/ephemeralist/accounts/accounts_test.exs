defmodule Ephemeralist.AccountsTest do 
  use Ephemeralist.DataCase
  alias Ephemeralist.{Accounts, Guardian}
  alias Ephemeralist.Accounts.{User, Credential}
  @valid_attrs %{name: "some name", username: "some_name"}
  @valid_user_credentials %{
    name: "some name", 
    username: "some_username",
    credential: %{
      email: "some_email@example.com",
      password: "Password1234"
    }
  }
  @invalid_attrs %{name: nil, username: ""}

  def user_fixture(attrs \\ %{}) do 
    {:ok, user} = Accounts.create_user attrs

    user
  end 

  describe "users" do 

    test "create_user/1 should return a user" do 
      expected_username = @valid_attrs.username 
      expected_name = @valid_attrs.name

      assert {:ok, %User{name: received_name, username: received_username}} =
        Accounts.create_user(@valid_attrs)

      assert received_name == expected_name 
      assert received_username == expected_username
    end 

    test "create_user/1 should return error changes set for invalid attrs" do 
      assert {:error, %Ecto.Changeset{valid?: false}} = 
        Accounts.create_user(@invalid_attrs)
    end 
  
    test "list_users/0 return all users" do 
      user = user_fixture(@valid_attrs)
      expected_username = user.username 
      expected_name =  user.name
      
      assert [%User{name: ^expected_name, username: ^expected_username}] = 
          Accounts.list_users()
    end 

    test "get_user/1 should return user struct for valid id" do 
      %User{id: id} = user_fixture(@valid_attrs)
      expected_username = @valid_attrs.username 
      expected_name =  @valid_attrs.name

      assert {:ok, %User{name: ^expected_name, username: ^expected_username}} = 
        Accounts.get_user(id)
    end 

    test "get_user/1 should return {:error, :user_not_found} for invalid id" do 
      id = -1337

      assert {:error, :user_not_found} = Accounts.get_user(id)
    end 

    test "get_user!/1 should return user struct for valid id" do 
      %User{id: id} = user_fixture(@valid_attrs)
      expected_username = @valid_attrs.username 
      expected_name =  @valid_attrs.name

      assert {:ok, %User{name: ^expected_name, username: ^expected_username}} = 
        Accounts.get_user!(id)
    end 

    test "get_user!/1 should return error" do 
      id = 1337

      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(id) end 
    end 

    test "register_user/1 should return user struct with credentials" do 
      assert {:ok, user, token} = 
        Accounts.register_user(@valid_user_credentials)

      {:ok, _, expected_resource} = Guardian.resource_from_token(token)
      received_id = expected_resource["sub"]
      expected_id = to_string(user.id)

      assert %User{credential: cred} = user
      assert cred.email == @valid_user_credentials.credential.email
      assert expected_id == received_id
    end 
  end 

  describe "token_sign_in/2" do 
    setup do 
      Accounts.register_user(@valid_user_credentials)
      email = @valid_user_credentials.credential.email 
      password = @valid_user_credentials.credential.password
      {:ok, email: email, password: password}
    end 

    test "should return token and user info", 
    %{email: email, password: pw}
    do 
      assert {:ok, user, token} =
        Accounts.token_sign_in(email, pw)
      
      {:ok, _, expected_resource} = Guardian.resource_from_token(token)
      received_id = expected_resource["sub"]
      expected_id = to_string(user.id)

      assert %User{credential: cred} = user
      assert cred.email == email
      assert expected_id == received_id
    end

    test "should return {:error, :unauthorized} for wrong password",
    %{email: email}
    do 
      assert {:error, :unauthorized} = 
        Accounts.token_sign_in(email, "wrong password")
    end 

    test "should return {:error, :user_not_found}" do 
      assert {:error, :user_not_found} =
        Accounts.token_sign_in("wrong_email@example.com", "password1234")
    end 
  end 

end 




