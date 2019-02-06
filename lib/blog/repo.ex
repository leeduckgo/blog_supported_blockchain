defmodule Blog.Repo do
  use Ecto.Repo, otp_app: :blog
  use Scrivener, page_size: 10
  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  def paginate_query(query, %{"page" => page, "page_size" => page_size}) do
    result = paginate(query, page: page, page_size: page_size)

    page_info = %{
      "page_number" => result.page_number,
      "page_size" => result.page_size,
      "total_count" => result.total_entries,
      "total_pages" => result.total_pages
    }

    {result.entries, page_info}
  end
end
