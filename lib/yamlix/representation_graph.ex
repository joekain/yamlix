defmodule RepresentationGraph do
  defmodule Node do
    defstruct value: "", tag: "", anchor: ""

    def new(list) when is_list(list) do
      new_list =
        Enum.map(list, fn val ->
          Node.new(val)
        end)

      %Node{value: new_list, tag: ""}
    end

    def new(map) when is_map(map) do
      new_map =
        Map.keys(map)
        |> List.foldl(%{}, fn key, acc ->
          new_key = Node.new(key)
          new_value = Map.get(map, key) |> Node.new()
          Map.put(acc, new_key, new_value)
        end)

      %Node{value: new_map, tag: ""}
    end

    def new(scalar) when is_atom(scalar) and not is_boolean(scalar) do
      %Node{value: scalar, tag: "!<tag:yamerl,2012:atom>"}
    end

    def new(scalar) do
      %Node{value: scalar, tag: ""}
    end

    def value(%Node{value: v, tag: _}) do
      v
    end
  end

  def represent(scalar) do
    Node.new(scalar)
  end
end
