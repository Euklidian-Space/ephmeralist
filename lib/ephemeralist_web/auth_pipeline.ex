defmodule Ephemeralist.Guardian.AuthPipeline do 
  use Guardian.Plug.Pipeline, otp_app: :ephemeralist,
  module: Ephemeralist.Guardian,
  error_handler: EphemeralistWeb.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end 