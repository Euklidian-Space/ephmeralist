defmodule Ephemeralist.Accounts.UserTest do 
  use Ephemeralist.DataCase
  alias Ephemeralist.Accounts.User

  @valid_attrs %{name: "some name", username: "some_name"}
  @invalid_attrs %{}

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
end 
