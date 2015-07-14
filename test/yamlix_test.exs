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

  test "it dumps floats" do
    assert Yamlix.dump(5.0) == "--- 5.0\n...\n"
  end

  test "it dumps bools (true)" do
    assert Yamlix.dump(true) == "--- true\n...\n"
  end

  test "it dumps bools (false)" do
    assert Yamlix.dump(false) == "--- false\n...\n"
  end

  test "it dumps atoms with yamerl tag" do
    assert Yamlix.dump(:a) == "--- !<tag:yamerl,2012:atom> a\n...\n"
  end

  test "it dumps atoms that can be read by yamerl" do
    assert [:a] == Yamlix.dump(:a)
    |> String.to_char_list
    |> :yamerl_constr.string([{:node_mods, [:yamerl_node_erlang_atom]}])
  end
end
