defmodule Blog.Repo.Migrations.UpdateYcyMessages do
  use Ecto.Migration

  def change do
    alter table(:ycy_messages) do
      add :group_name, :string
      modify(:inserted_at, :timestamp, default: fragment("NOW()"))
      modify(:updated_at, :timestamp, default: fragment("NOW()"))
    end
  end
end
