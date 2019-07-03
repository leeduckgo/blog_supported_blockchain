defmodule Auth do
  def auth?(api_key) do
    api_key == auth_key()
  end

  def auth_key, do: Application.get_env(:blog, BlogWeb.Endpoint) |> Keyword.fetch!(:apikey)
end
