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

  def create(conn, %{"api" => api_key, "group" => group_puid, "users" => users}) do
    if Auth.auth?(api_key) do
      group = YcyGroup.get_group_by_id(group_puid)
      YcyUser.insert(users, group.id)
      json(conn, %{status: :ok})
    else
      json(conn, %{status: :error})
    end
  end

  def transfer(conn, %{"api" => api_key, "from" => from, "to" => to, "amount" => amount}) do
    if Auth.auth?(api_key) do
      {status, _result} = YcyUser.transfer(from, to, amount)
      case status do
        :ok ->
          json(conn, %{status: "success"})
        :error ->
          json(conn, %{status: "fail"})
      end
    else
      json(conn, %{status: "fail"})
    end
  end

end
