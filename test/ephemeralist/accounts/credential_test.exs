defmodule Ephemeralist.CredentialTest do 
  use Ephemeralist.DataCase 
  alias Ephemeralist.Accounts.Credential
  alias Ephemeralist.Repo

  @valid_credentials %{email: "some@email.com", password: "Password1234"}
  @invalid_credentials %{}

  test "changeset with valid attributes" do 
    assert %Ecto.Changeset{valid?: true} = 
      Credential.changeset(%Credential{}, @valid_credentials)
  end 

  test "changeset with invalid attributes" do 
    cs =  Credential.changeset(%Credential{}, @invalid_credentials)
    assert %Ecto.Changeset{valid?: false} = cs
  end

  test "password must be atleast 8 characters" do 
    errors = [
      password: {"should be at least %{count} character(s)", 
        [count: 8, validation: :length, min: 8]
      }
    ]
    invalid_attrs = Map.put(@valid_credentials, :password, "123")

    %Ecto.Changeset{errors: received} = 
      Credential.changeset(%Credential{}, invalid_attrs)

    assert errors == received
  end 

  test "emails should be unique" do 
    Credential.changeset(%Credential{}, @valid_credentials)    
    |> Repo.insert
    
    assert {:error, cs} = 
      Credential.changeset(%Credential{}, @valid_credentials)    
      |> Repo.insert

    expected = %{email: ["has already been taken"]}
      
    assert errors_on(cs) == expected
  end 

  test "pasword should be saved as a hash" do 
    {:ok, %Credential{password_hash: pw_hash}} = 
      Credential.changeset(%Credential{}, @valid_credentials)
      |> Repo.insert

    assert Comeonin.Bcrypt.checkpw(@valid_credentials.password, pw_hash) 
  end 

end 
