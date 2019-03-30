defmodule Article do
  @moduledoc """
  Chain schema.
  """
  use Directive, :schema

  # many articles belong an author
  schema "articles" do
    field(:title, :string)
    field(:abstract, :string)
    field(:type, :string)
    field(:body, :string)
    field(:user_id, :integer)
    field(:category, Category.CategoryType)
    field(:group_ids, {:array, :integer})
    timestamps()
  end

  def get_articles(user, %{"page" => page, "page_size" => page_size}) when is_nil(user) do
    group_id = 0
    get_articles(group_id, page, page_size)
  end

  def get_articles(user, %{"page" => page, "page_size" => page_size}) do
    group_id = user.group_id
    get_articles(group_id, page, page_size)
  end

  defp get_articles(group_id, page, page_size) do
    {articles, page_info} =
      Article
      |> where([a], ^group_id in a.group_ids)
      |> Repo.paginate_query(%{"page" => page, "page_size" => page_size})

    summary_articles =
      Enum.map(articles, fn article ->
        handle(article)
      end)

    %{"entries" => summary_articles, "page_info" => page_info}
  end

  def handle(article) do
    article
    |> Map.delete(:body)
    |> StructTranslater.struct_to_map()
  end

  def get_article_by_id(id) do
    Article
    |> where(id: ^id)
    |> Repo.one()
  end

  def insert(article) do
    Article
    |> StructTranslater.to_struct(article)
    |> Repo.insert()
  end
end
