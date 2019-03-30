defmodule BlogWeb.YcyUserController do
  use BlogWeb, :controller

  def show(conn, %{"puid" => puid}) do

    user_info =
      puid
      |> YcyUser.get_user_by_puid()
      |> StructTranslater.struct_to_map()
      |> Map.delete(:ycy_group)
    IO.puts inspect(user_info)
    json(conn, user_info)
  end

  def create(conn, params) do
    %{"users" => users} = params
    YcyUser.insert(users)
    json(conn, %{status: :ok})
  end
end
