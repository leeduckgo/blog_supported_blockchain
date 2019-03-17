defmodule Blog.Repo.Migrations.CreateYcyUsers do
  use Ecto.Migration

  def change do
    create table(:ycy_users) do
      add :puid, :string
      add :name, :string
      add :level, :integer
      add :balance, :integer
      add :group_id, :integer
    end

    create table(:ycy_groups) do
      add :puid, :string
      add :level, :integer
      add :introduction, :text
    end
  end
end
