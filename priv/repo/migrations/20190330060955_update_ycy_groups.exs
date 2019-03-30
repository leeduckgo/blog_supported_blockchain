defmodule Blog.Repo.Migrations.UpdateYcyGroups do
  use Ecto.Migration

  def change do
    alter table(:ycy_groups) do
      add(:admin_puid, :string)
    end
  end
end
