defmodule YamlixTest do
  use ExUnit.Case

  test "it dumps integer scalars" do
    assert Yamlix.dump(5) == "--- 5\n...\n"
  end
end
