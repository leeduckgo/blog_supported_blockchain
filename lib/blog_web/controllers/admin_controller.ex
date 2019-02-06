defmodule BlogWeb.AdminController do
  use BlogWeb, :controller
  import BlogWeb.UserController, only: [load_current_user: 2]
  plug(:load_current_user when action in [:show])

end
