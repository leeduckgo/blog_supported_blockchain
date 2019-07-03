defmodule BlogWeb.YcyGroupController do
  use BlogWeb, :controller

  def show(conn, %{"puid" => puid}) do
    try do
      group_info =
        puid
        |> YcyGroup.get_group_by_id()
        |> StructTranslater.struct_to_map()
        |> Map.delete(:ycy_users)

      json(conn, group_info)
    rescue
      _ ->
        json(conn, %{"result" => "no_exist"})
    end
  end

  def create(conn, %{"api" => api_key, "group" => group_info}) do
    if Auth.auth?(api_key) do
      {status, _result} = YcyGroup.insert(group_info)
      json(conn, %{status: status})
    else
      json(conn, %{status: "fail"})
    end
  end
end
