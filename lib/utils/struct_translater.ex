defmodule StructTranslater do
  def to_struct(kind, attrs) do
    struct = struct(kind)

    Enum.reduce(Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end)
  end

  def struct_to_map(struct) do
    map =
      struct
      |> Map.from_struct()
      |> Map.delete(:__meta__)

    :maps.filter(fn _, v -> Ecto.assoc_loaded?(v) end, map)
  end
end
