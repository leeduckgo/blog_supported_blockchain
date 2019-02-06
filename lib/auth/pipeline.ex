defmodule Auth.AuthAccessPipeline do

  @moduledoc """
  i. Guardian.Plug.VerifySession — looks for a token in the session and verifies it

  ii. Guardian.Plug.EnsureAuthenticated — makes sure that a token was found and is valid

  iii. Guardian.Plug.LoadResource — if a token was found, loads the resource for it
  """

  use Guardian.Plug.Pipeline, otp_app: :blog

  plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)

end

