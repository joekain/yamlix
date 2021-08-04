defmodule Serialize do
  alias RepresentationGraph.Node

  def serialize(graph) do
    graph |> generate_anchors
  end

  def generate_anchors(tree) do
    {new_tree, _} = do_generate_anchors(tree, 1)
    new_tree
  end

  defp do_generate_anchors(%Node{value: list, tag: t, anchor: ""}, count) when is_list(list) do
    {new_list, new_count} =
      Enum.reduce(list, {[], count}, fn elem, {new_list, count} ->
        {new_elem, count} = do_generate_anchors(elem, count)
        {[new_elem | new_list], count}
      end)

    {%Node{value: Enum.reverse(new_list), tag: t, anchor: new_count}, new_count + 1}
  end

  defp do_generate_anchors(%Node{value: map, tag: t, anchor: ""}, count) when is_map(map) do
    {new_map, new_count} =
      List.foldl(Map.keys(map), {Map.new(), count}, fn key, {new_map, count} ->
        {key_node, count} = do_generate_anchors(key, count)
        {value_node, count} = do_generate_anchors(Map.get(map, key), count)
        {Map.put_new(new_map, key_node, value_node), count}
      end)

    {%Node{value: new_map, tag: t, anchor: new_count}, new_count + 1}
  end

  defp do_generate_anchors(%Node{value: scalar, tag: t, anchor: ""}, count) do
    {%Node{value: scalar, tag: t, anchor: count}, count + 1}
  end
end
