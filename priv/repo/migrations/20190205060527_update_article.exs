defmodule Blog.Repo.Migrations.UpdateArticle do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :group_ids, {:array, :integer}, default: "{0}"
      add :abstract, :string
      add :category, :integer
    end
  end
end
