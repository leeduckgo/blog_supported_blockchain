defmodule Blog.Repo.Migrations.UpdateUserArticle do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :abstract, :string
    end

    alter table(:users) do
      add :group_id, :integer
    end
  end
end
