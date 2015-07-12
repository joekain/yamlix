defmodule RepresentationGraph do
  defmodule Node do
    defmodule Scalar do
      defstruct value: "", tag: ""
    end

    def new(scalar) do
      %Scalar{value: scalar, tag: ""}
    end

    def value(%Scalar{value: v, tag: _}) do
      v
    end
  end

  def represent(scalar) do
    Node.new(scalar)
  end
end
