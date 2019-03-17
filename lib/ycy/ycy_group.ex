defmodule YcyGroup do
  use Directive, :schema

  # ycy_groups
  schema "ycy_groups" do
    field :puid, :string
    field :level, :integer
    field :introduction, :string
    timestamps()
  end
  def get_groups() do
    Repo.all(YcyGroup)
  end

  def get_group_by_id(group_id) do
    YcyGroup
    |> where(puid: ^group_id)
    |> Repo.one()
  end
  def insert(group) do
    YcyMessage
    |> StructTranslater.to_struct(group)
    |> Repo.insert()
  end
end
