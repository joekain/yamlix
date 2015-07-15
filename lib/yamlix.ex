defmodule Yamlix do
  alias RepresentationGraph, as: R;
  alias RepresentationGraph.Node;

  @spec dump(any) :: String.t
  def dump(scalar) do
    scalar |> R.represent |> serialize |> present
  end

  defp serialize(graph) do
    graph
  end

  defp present(tree) do
    "--- " <>
    to_string(tree) <>
    "\n...\n"
  end
end
