defmodule Yamlix do
  alias RepresentationGraph, as: R;
  alias RepresentationGraph.Node;

  @spec dump(any) :: String.t
  def dump(scalar) do
    scalar |> R.represent |> serialize |> present
  end

  defp serialize(node) do
    to_string(node)
  end

  defp present(content) do
    "--- " <>
    content  <>
    "\n...\n"
  end
end
