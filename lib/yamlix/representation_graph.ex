defmodule RepresentationGraph do
  defmodule Node do
    defstruct value: "", tag: ""

    def new(list) when is_list(list) do
      new_list = list |> Enum.map fn val ->
        Node.new(val)
      end
      %Node{value: new_list, tag: ""}
    end

    def new(map) when is_map(map) do
      new_map = Map.keys(map) |> List.foldl %{}, fn (key, acc) ->
        new_key = key |> Node.new
        new_value = Map.get(map, key) |> Node.new
        Map.put(acc, new_key, new_value)
      end
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

  defimpl String.Chars, for: Node do
    def to_string(%Node{value: list, tag: _}) when is_list(list) do
      list |> List.foldl "", fn val, acc ->
        acc <> "\n- #{val}"
      end
    end

    def to_string(%Node{value: map, tag: _}) when is_map(map) do
      Map.keys(map) |> List.foldl "", fn key, acc ->
        acc <> "\n#{key}: #{Map.get(map, key)}"
      end
    end

    def to_string(%Node{value: v, tag: t}) do
      tag_and_space(t) <> Kernel.to_string(v)
    end

    defp tag_and_space(t) do
      case t do
        "" -> ""
        tag -> tag <> " "
      end
    end
  end
end
