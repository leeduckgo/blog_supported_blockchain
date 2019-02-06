defmodule WebHandler do
  def handle_www_form(params) do
    params
    |> Map.keys()
    |> Enum.fetch!(0)
    |> Poison.decode()
  end
end
