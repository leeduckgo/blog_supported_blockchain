defmodule Blog.Repo.Migrations.YcyMessages do
  use Ecto.Migration

  def change do
    create table(:ycy_messages) do
      add :fans_id, :string
      add :name, :string
      add :context, :text
      timestamps()
    end
  end
end
