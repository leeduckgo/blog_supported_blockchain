defmodule YcyMessage do
  use Directive, :schema

  # ycy_messages
  schema "ycy_messages" do
    field(:fans_id, :string)
    field(:name, :string)
    field(:context, :string)
    field(:group_name, :string)
    timestamps()
  end

  def get_messages() do
    Repo.all(YcyMessage)
  end

  def insert(msg) do
    YcyMessage
    |> StructTranslater.to_struct(msg)
    |> Repo.insert()
  end
end
