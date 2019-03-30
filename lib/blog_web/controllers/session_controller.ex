defmodule BlogWeb.SessionController do
  alias BlogWeb.UserController
  alias WebHandler
  use BlogWeb, :controller

  @doc """
  suit 「application/json」
  """
  def create(conn, %{"password" => password, "username" => user}) do
    create(conn, user, password)
  end

  # @doc """
  #   suit 「application/x-www-form-urlencoded」
  # """
  # def create(conn, params) do
  #   {:ok, %{"password" => password, "username" => user}} =
  #     WebHandler.handle_www_form(params)

  #   create(conn, user, password)
  # end

  defp create(conn, user, password) do
    case User.authenticate_user(user, password) do
      {:ok, user} ->
        conn = UserController.login(conn, user)
        json(conn, "success!")

      {:error, _reason} ->
        json(conn, "Invalid username/password combination")
    end
  end

  def delete(conn, _) do
    conn
    |> UserController.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
