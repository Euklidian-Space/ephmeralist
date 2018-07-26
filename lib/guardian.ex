defmodule Ephemeralist.Guardian do 
  use Guardian, otp_app: :ephemeralist
  alias Ephemeralist.Accounts

  def subject_for_token(user, _claims) do 
    sub = to_string(user.id)
    {:ok, sub}
  end 

  def resource_from_claims(claims) do 
    id = claims["sub"]
    Accounts.get_user(id)
  end 

end 
