defmodule Auth.Guardian do
  @moduledoc false

  use Guardian, otp_app: :blog
  alias User

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    user = User.get_user(id)
    {:ok, user}
  end
end
