defmodule YcyMessages do

  use Directive, :schema

  # ycy_messages
  schema "ycy_messages" do
    field :fans_id, :string
    field :name, :string
    field :context, :string
    timestamps()
  end
  def get_messages() do
    Repo.all(YcyMessages)
  end
end
