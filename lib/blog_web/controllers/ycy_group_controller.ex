defmodule BlogWeb.YcyGroupController do
  use BlogWeb, :controller

  def show(conn, %{"puid" => puid}) do
    group_info =
      puid
      |> YcyGroup.get_group_by_id()
      |> StructTranslater.struct_to_map()

    json(conn, group_info)
  end

  def create(conn, params) do
    {status, _result} = YcyMessage.insert(params)
    json(conn, %{status: status})
  end
end
