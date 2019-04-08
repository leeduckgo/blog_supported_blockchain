defmodule Blog.Repo.Migrations.CreateRealEstate do
  use Ecto.Migration

  def change do
    alter table(:ycy_groups) do
      add(:is_enabled, :boolean, default: false)
    end

    alter table(:ycy_users) do
      add :ycy_real_estate_id, :integer
    end

    create table(:ycy_real_estates) do
      add :name, :string
      add :signature, :string
      add :price, :integer
      add :ycy_user_id, :integer
      add(:inserted_at, :timestamp, default: fragment("NOW()"))
      add(:updated_at, :timestamp, default: fragment("NOW()"))
    end
  end
end
