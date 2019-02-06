defmodule Blog.Repo.Migrations.UpdateArticle do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      remove :group_ids
    end
  end
end
