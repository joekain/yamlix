defmodule YamlixTest do
  use ExUnit.Case

  test "it dumps integer scalars" do
    assert Yamlix.dump(5) == "--- 5\n...\n"
  end

  test "it dumps string scalars" do
    assert Yamlix.dump("s") == "--- s\n...\n"
  end

  test "it dumps maps of strings" do
    map = %{"key1" => "value1", "key2" => "value2"}
    assert Yamlix.dump(map) == """
    --- 
    key1: value1
    key2: value2
    ...
    """
  end
end
