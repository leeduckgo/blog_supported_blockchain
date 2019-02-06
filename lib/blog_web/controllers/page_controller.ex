defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"id" => id}) do
    render(conn, "articles.html", id: id)
  end
end
