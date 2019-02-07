defmodule Blog.Repo.Migrations.UpdateUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password_hash, :string
      add :password, :string
      add :group_id, :integer
      add :avatar, :string
    end
  end
end
