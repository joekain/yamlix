defmodule Presentation do
  alias RepresentationGraph.Node
  @special_chars ~w(: { } [ ] , & * # ? | - < > = ! % @ \\)

  def present(tree, wrap \\ true) do
    if wrap do
      "--- " <>
        produce(tree) <>
        "...\n"
    else
      produce(tree)
    end
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
    list
    |> List.foldl("\n", fn val, acc ->
      acc <> indent(n) <> "- " <> sequence_element(val, n + 1)
    end)
  end

  defp sequence_element(%Node{value: list, tag: t}, n) when is_list(list) do
    block_sequence(%Node{value: list, tag: t}, n)
  end

  defp sequence_element(%Node{value: map, tag: t}, n) when is_map(map) do
    case Map.keys(map) do
      [] ->
        "{}\n"

      [key | keys] ->
        mapping_pair(map, key, n) <>
          (keys
           |> List.foldl("", fn key, acc ->
             acc <> indent(n) <> mapping_pair(map, key, n)
           end))
    end
  end

  defp sequence_element(node, _n) do
    literal(node, 0) <> "\n"
  end

  defp block_mapping(%Node{value: map, tag: t}, n) do
    Map.keys(map)
    |> List.foldl("\n", fn key, acc ->
      acc <> indent(n) <> mapping_pair(map, key, n)
    end)
  end

  defp mapping_pair(map, key, n) do
    literal(key, 0) <> ":" <> mapping_value(Map.get(map, key), n)
  end

  defp mapping_value(%Node{value: list, tag: t}, n) when is_list(list) do
    block_sequence(%Node{value: list, tag: t}, n)
  end

  defp mapping_value(%Node{value: map, tag: t}, n) when is_map(map) do
    block_mapping(%Node{value: map, tag: t}, n + 1)
  end

  defp mapping_value(node, _n) do
    " " <> literal(node, 0) <> "\n"
  end

  defp literal(%Node{value: val, tag: t}, n) do
    indent(n) <> tag_and_space(t) <> escape(Kernel.to_string(val))
  end

  defp tag_and_space(t) do
    case t do
      "" -> ""
      tag -> tag <> " "
    end
  end

  @spec indent(non_neg_integer) :: String.t()
  defp indent(0), do: ""

  defp indent(level) do
    String.duplicate(" ", level * 2)
  end

  defp escape(string) do
    if String.contains?(string, @special_chars) do
      "\"#{string}\""
    else
      string
    end
  end
end
