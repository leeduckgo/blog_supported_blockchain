defmodule Blog.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :type, :string
      add :body, :text
      add :user_id, :integer
      timestamps()
    end
  end
end
