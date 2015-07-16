defmodule Yamlix do
  alias RepresentationGraph, as: R
  alias Presentation, as: P

  @spec dump(any) :: String.t
  def dump(scalar) do
    scalar |> R.represent |> serialize |> P.present
  end

  defp serialize(graph) do
    graph
  end
end
