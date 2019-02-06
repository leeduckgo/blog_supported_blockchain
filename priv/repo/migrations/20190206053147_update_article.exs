defmodule Blog.Repo.Migrations.UpdateArticle do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :category, :integer
    end
  end
end
