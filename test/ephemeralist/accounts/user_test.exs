defmodule Ephemeralist.Accounts.UserTest do 
  use Ephemeralist.DataCase
  alias Ephemeralist.Accounts.User
  alias Ephemeralist.Repo

  @valid_attrs %{
    name: "some name",
    username: "some_name",
    credential: %{
      password: "Password1234",
      email: "some@email.com"
    }
  }

  @invalid_attrs %{}

  describe "changeset/2" do 
    test "changeset with valid attributes" do 
      assert %Ecto.Changeset{valid?: true} = 
        User.changeset(%User{}, @valid_attrs)
    end 

    test "changeset with invalid attributes" do 
      assert %Ecto.Changeset{valid?: false} = 
        User.changeset(%User{}, @invalid_attrs)
    end 

    test "changeset with username not of the minimum length" do 
      attrs = Map.put(@valid_attrs, :username, "abc")
      assert %Ecto.Changeset{valid?: false} =
        User.changeset(%User{}, attrs)
    end 

    test "username should be unique" do 
      %User{}
      |> User.changeset(@valid_attrs)
      |> Repo.insert

      assert {:error, changeset} = 
        User.changeset(%User{}, @valid_attrs)
        |> Repo.insert

      expected = %{username: ["has already been taken"]}

      assert errors_on(changeset) == expected
    end 
  end 

  describe "registration_changeset/2" do 
    test "registration_changeset with valid_attrs" do 
      assert %Ecto.Changeset{valid?: true} = 
        User.registration_changeset(%User{}, @valid_attrs)
    end 

    test "registration_changeset with invalid attributes" do 
      received_errs = User.registration_changeset(%User{}, @invalid_attrs)
                      |> errors_on
      expected = %{
        credential: ["can't be blank"],
        username: ["can't be blank"],
        name: ["can't be blank"]
      }

      assert received_errs == expected
    end 
  end 

end 
