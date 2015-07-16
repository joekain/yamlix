defmodule Presentation do
  alias RepresentationGraph.Node
  
  @m 2
  
  def present(tree) do
    "--- " <>
    generate_yaml(tree) <>
    "...\n"
  end
  
  defp generate_yaml(node) do
    produce(node)
  end
  
  defp produce(%Node{value: list, tag: t}) when is_list(list) do
    block_sequence(%Node{value: list, tag: t}, 0)
  end
  defp produce(%Node{value: map, tag: t}) when is_map(map) do
    block_mapping(%Node{value: map, tag: t}, 0)
  end
  defp produce(node) do
    literal(node, 0) <> "\n"
  end
  
  defp block_sequence(%Node{value: list, tag: t}, n) do
    list |> List.foldl "\n", fn val, acc ->
      acc <> indent(n) <> "- " <> sequence_element(val, n + @m)
    end
  end
  
  defp sequence_element(%Node{value: list, tag: t}, n) when is_list(list) do
    block_sequence(%Node{value: list, tag: t}, n)
  end
  defp sequence_element(%Node{value: map, tag: t}, n) when is_map(map) do
    [key | keys] = Map.keys(map)
    
    mapping_pair(map, key, n) <> (
      keys |> List.foldl "", fn key, acc ->
        acc <> indent(n) <> mapping_pair(map, key, n)
      end
    )
  end
  defp sequence_element(node, _n) do
    literal(node, 0) <> "\n"
  end
  
  defp block_mapping(%Node{value: map, tag: t}, n) do
    Map.keys(map) |> List.foldl "\n", fn key, acc ->
      acc <> indent(n) <> mapping_pair(map, key, n)
    end
  end
  
  defp mapping_pair(map, key, n) do
    literal(key, 0) <> ":" <> mapping_value(Map.get(map, key), n)
  end
  
  defp mapping_value(%Node{value: list, tag: t}, n) when is_list(list) do
    block_sequence(%Node{value: list, tag: t}, n)
  end
  defp mapping_value(%Node{value: map, tag: t}, n) when is_map(map) do
    block_mapping(%Node{value: map, tag: t}, n + @m)
  end
  defp mapping_value(node, _n) do
    " " <> literal(node, 0) <> "\n" 
  end

  defp literal(%Node{value: val, tag: t}, n) do
    indent(n) <> Kernel.to_string(val)
  end
 
  
  #########################################################


  def format(%Node{value: list, tag: _}, level) when is_list(list) do
    list |> List.foldl "\n", fn val, acc ->
      acc <> indent(level - 1) <> "- " <> format(val, 0) <> "\n"
    end
  end

  def format(%Node{value: map, tag: _}, level) when is_map(map) do
    Map.keys(map) |> List.foldl "", fn key, acc ->
      acc <> indent(level) <> format(key, 0) <> ": " <> format(Map.get(map, key), level + 1) <> "\n"
    end
  end

  def format(%Node{value: v, tag: t}, _level) do
    tag_and_space(t) <> Kernel.to_string(v)
  end
  
  defp tag_and_space(t) do
    case t do
      "" -> ""
      tag -> tag <> " "
    end
  end
  
  defp indent(count) do
    String.duplicate(" ", count)
  end
end
