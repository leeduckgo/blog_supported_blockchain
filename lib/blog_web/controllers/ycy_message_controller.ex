defmodule BlogWeb.YcyMessageController do
  use BlogWeb, :controller

  # def show(conn, _params) do
  #   conn = put_layout(conn, "ycy_app.html")
  #   render(conn, "ycy_messages.html")
  # end

  def show(conn, _params) do
    msgs = YcyMessage.get_messages()
    msgs_map = Enum.map(msgs, fn msg ->
      StructTranslater.struct_to_map(msg)
    end)
    json(conn, msgs_map)
  end

  def create(conn, params) do
    {status, _result} = YcyMessage.insert(params)
    json(conn, %{status: status})
  end

end
