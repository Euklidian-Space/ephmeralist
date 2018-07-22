defmodule Ephemeralist.AccountsTest do 
  use Ephemeralist.DataCase
  alias Ephemeralist.Accounts 
  alias Ephemeralist.Accounts.User

  describe "users" do 
    @valid_attrs %{name: "some name", username: "some_name"}
    @invalid_attrs %{name: nil, username: ""}

    def user_fixture(attrs \\ %{}) do 
      {:ok, user} = Accounts.create_user attrs

      user
    end 

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
      id = 1337

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
  end 
end 




