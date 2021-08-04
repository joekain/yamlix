defmodule Yamlix do
  alias RepresentationGraph, as: R
  alias Serialize, as: S
  alias Presentation, as: P

  @spec dump(any) :: String.t()
  def dump(scalar, wrap \\ true) do
    scalar |> R.represent() |> S.serialize() |> P.present(wrap)
  end
end
