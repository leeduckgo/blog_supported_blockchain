defmodule Blog.Repo.Migrations.UpdateYcyUser do
  use Ecto.Migration

  def change do
    rename table(:ycy_users), :group_id, to: :ycy_group_id
  end
end
