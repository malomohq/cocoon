defmodule CocoonTest do
  use ExUnit.Case, async: true

  describe "transform/2" do
    test "transforms data" do
      v1 = Enum.random(["value1", "value2"])
      v2 = Enum.random(1..10)
      data = %{ "k1" => v1, "k2" => v2 }

      mappings = [{ :k1, ["k1"] }, { :k2, ["k2"], &to_string/1 }]

      v2_trans = to_string(v2)

      assert %{ k1: ^v1, k2: ^v2_trans } = Cocoon.transform(data, mappings)
    end
  end
end
