defmodule BlogWeb.YcyController do
  use BlogWeb, :controller

  # def show(conn, _params) do
  #   conn = put_layout(conn, "ycy_app.html")
  #   render(conn, "ycy_messages.html")
  # end

  def show(conn, _params) do
    msgs = YcyMessages.get_messages()
    msgs_map = Enum.map(msgs, fn msg ->
      StructTranslater.struct_to_map(msg)
    end)
    json(conn, msgs_map)
  end

end
