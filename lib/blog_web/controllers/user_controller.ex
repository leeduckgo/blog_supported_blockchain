defmodule BlogWeb.UserController do
  use BlogWeb, :controller

  plug(:load_current_user when action in [:show])

  def login(conn, user) do
    conn
    |> Auth.Guardian.Plug.sign_in(user)
    |> assign(:current_user, user)
  end

  def logout(conn) do
    conn
    |> Auth.Guardian.Plug.sign_out()
  end

  def show(conn, %{"id" => id}) do
    map_user =
    id
    |> User.get_user()
    |> Map.delete(:articles)
    |> StructTranslater.struct_to_map()
    json(conn, map_user)
  end

  def load_current_user(conn, _) do
      Plug.Conn.assign(conn, :current_user,
      Auth.Guardian.Plug.current_resource(conn))
    end
end
