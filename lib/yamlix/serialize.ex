defmodule Serialize do
  alias RepresentationGraph.Node

  def serialize(graph) do
    graph
  end
  
  def generate_anchors(tree) do
    do_generate_anchors(tree, 1)
  end
  
  defp do_generate_anchors(%Node{value: list, tag: t, anchor: ""}, value) when is_list(list) do
    %Node {
      anchor: value,
      tag: t,
      value: Enum.map(list, fn elem ->
        do_generate_anchors(elem, value)
      end)
    }
  end
  defp do_generate_anchors(%Node{value: map, tag: t, anchor: ""}, value) when is_map(map) do
    %Node {
      anchor: value,
      tag: t,
      value: List.foldl(Map.keys(map), %{}, fn key, acc ->
        Map.put_new(acc, do_generate_anchors(key, value), do_generate_anchors(Map.get(map, key), value))
      end)
    }
  end
  defp do_generate_anchors(%Node{value: scalar, tag: t, anchor: ""}, value) do
    %Node{value: scalar, tag: t, anchor: value}
  end
end
