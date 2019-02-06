defmodule BlogWeb.ArticleController do
  use BlogWeb, :controller
  import BlogWeb.UserController, only: [load_current_user: 2]
  plug(:load_current_user when action in [:create, :show])

  alias WebHandler
  alias Article
  alias User

  @doc """
  Get an article
  """
  def show(conn, %{"id" => id}) do
    map_article =
      id
      |> Article.get_article_by_id()
      |> StructTranslater.struct_to_map()
    json(conn, map_article)
  end

  @doc """
  Get articles by Scrivener
  """
  def show(conn, page_info) do
    user = conn.assigns.current_user
    articles_and_page_info = Article.get_articles(user, page_info)
    json(conn, articles_and_page_info)
  end

  @doc """
  Create an article
  """
  def create(conn, params) do
    user = conn.assigns.current_user
    IO.puts inspect(user)
    if User.admin?(user) do
      {:ok, result} = Article.insert(params)
      map_result = StructTranslater.struct_to_map(result)
      json(conn, map_result)
    else
      json(conn, "you're not admin!")
    end

  end

end
