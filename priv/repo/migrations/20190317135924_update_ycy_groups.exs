defmodule Blog.Repo.Migrations.UpdateYcyGroups do
  use Ecto.Migration

  def change do
    alter table(:ycy_groups) do
      add(:inserted_at, :timestamp, default: fragment("NOW()"))
      add(:updated_at, :timestamp, default: fragment("NOW()"))
    end
  end
end
