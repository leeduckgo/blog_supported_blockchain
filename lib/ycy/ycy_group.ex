defmodule YcyGroup do
  use Directive, :schema

  # ycy_groups
  schema "ycy_groups" do
    field(:puid, :string)
    field(:level, :integer)
    field(:introduction, :string)
    field(:admin_puid, :string)
    has_many(:ycy_users, YcyUser)
    timestamps()
  end

  def get_groups() do
    Repo.all(YcyGroup)
  end

  def get_group_by_id(group_id) when is_integer(group_id) do
    YcyGroup
    |> where(id: ^group_id)
    |> Repo.one()
  end
  def get_group_by_id(group_id) do
    YcyGroup
    |> where(puid: ^group_id)
    |> Repo.one()
  end

  def insert(group) do
    YcyGroup
    |> StructTranslater.to_struct(group)
    |> Repo.insert()
  end
end
