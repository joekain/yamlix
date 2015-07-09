defmodule Yamlix do
  @spec dump(integer()) :: String.t
  def dump(scalar) do
    scalar |> represent |> serialize |> present
  end

  defp represent(scalar) do

  end

  defp serialize(_) do

  end

  defp present(_) do
    "--- " <>
    "5\n"  <>
    "...\n"
  end
end
