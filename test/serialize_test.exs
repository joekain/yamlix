defmodule SerializeTest do
  use ExUnit.Case
  
  alias RepresentationGraph, as: R
  alias RepresentationGraph.Node
  alias Serialize, as: S
  
  test "it adds an anchor to list nodes" do
    structure = ["a", "b", "c"]
    %RepresentationGraph.Node {
      anchor: anchor_list, value: [
        %RepresentationGraph.Node{value: "a", anchor: anchor_a},
        %RepresentationGraph.Node{value: "b", anchor: anchor_b},
        %RepresentationGraph.Node{value: "c", anchor: anchor_c}
      ]
    } = R.represent(structure) |> S.generate_anchors
    
    assert anchor_list != ""
    assert anchor_a != ""
    assert anchor_b != ""
    assert anchor_c != ""
  end
  
  test "it adds an anchor to map nodes" do
    structure = %{ "a" => "b", "c" => "d" }
    %Node{anchor: anchor_map, tag: "", value: map} = R.represent(structure) |> S.generate_anchors
    
    assert anchor_map != ""
    assert Map.keys(map)   |> Enum.all? fn %Node{anchor: anchor} -> anchor != "" end
    assert Map.values(map) |> Enum.all? fn %Node{anchor: anchor} -> anchor != "" end
  end
  
  @tag :disable
  test "it should create unique anchor values" do
    structure = %{ "a" => "b", "c" => "d" }
    tree = R.represent(structure) |> S.generate_anchors
    
    anchors = for list <- [ [tree], Map.keys(tree.value), Map.values(tree.value) ], node <- list do
      node.anchor
    end
    
    assert Enum.count(anchors) == Enum.uniq(anchors) |> Enum.count
  end
end