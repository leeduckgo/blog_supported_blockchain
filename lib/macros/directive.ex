defmodule Directive do
  @moduledoc """
  Macro of Schema.
  """

  def schema() do
    quote do
      use Ecto.Schema
      alias __MODULE__
      import Ecto.{Query, Queryable, Changeset}
      import EctoEnum, only: [defenum: 2]
      alias  Blog.Repo

      def last(n \\ 1) do
        __MODULE__
        |> order_by(desc: :id)
        |> limit(^n)
        |> Repo.all()
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

end
