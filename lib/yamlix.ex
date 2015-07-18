defmodule Yamlix do
  alias RepresentationGraph, as: R
  alias Serialize, as: S
  alias Presentation, as: P

  @spec dump(any) :: String.t
  def dump(scalar) do
    scalar |> R.represent |> S.serialize |> P.present
  end
end
