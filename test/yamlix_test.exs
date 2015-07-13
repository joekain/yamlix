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

  test "it dumps emtpy maps" do
    assert Yamlix.dump(%{}) == """
    --- 
    ...
    """
  end

  test "it dumps emtpy lists" do
    assert Yamlix.dump([]) == """
    --- 
    ...
    """
  end

  test "it dumps lists of strings" do
    list = ["one", "two"]
    assert Yamlix.dump(list) == """
    --- 
    - one
    - two
    ...
    """
  end
end
