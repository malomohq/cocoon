defmodule Cocoon.TransformerTest do
  use ExUnit.Case, async: true

  alias Cocoon.{ Transformer }

  describe "call/2" do
    test "transforms nil with no errors" do
      mappings = [{ :k1, ["k1"] }]

      assert %{ k1: nil } = Transformer.call(nil, mappings)
    end

    test "transforms an empty map with no errors" do
      mappings = [{ :k1, ["k1"] }, { :k2, ["k2"] }]

      assert %{ k1: nil, k2: nil } = Transformer.call(%{}, mappings)
    end

    test "transforms an empty list with no errors" do
      mappings = [{ :k1, ["k1"] }]

      assert [] = Transformer.call([], mappings)
    end

    test "excludes keys without a corresponding mappings" do
      data = %{ "k1" => gen_string(), "k2" => gen_string() }

      mappings = [{ :k1, ["k1"] }]

      refute match?(%{ "k2" => _value }, Transformer.call(data, mappings))
    end

    test "transforms a map" do
      v1 = gen_string()
      v2 = gen_string()
      data = %{ "k1" => v1, "k2" => v2 }

      mappings = [{ :k1, ["k1"] }, { :k2, ["k2"] }]

      assert %{ k1: ^v1, k2: ^v2 } = Transformer.call(data, mappings)
    end

    test "transforms a deeply nested map" do
      nested_map = %{ "key" => "value" }
      data = %{ "k1" => %{ "k2" => nested_map } }

      mappings = [{ :k2, ["k1", "k2"] }]

      assert %{ k2: ^nested_map } = Transformer.call(data, mappings)
    end

    test "transforms a list of maps" do
      v1 = gen_string()
      v2 = gen_string()
      data = [%{ "k1" => v1 }, %{ "k1" => v2 }]

      mappings = [{ :k1, ["k1"] }]

      assert [%{ k1: ^v1 }, %{ k1: ^v2 }] = Transformer.call(data, mappings)
    end

    test "transforms values when function is present" do
      v1 = Enum.random(1..10)
      data = %{ "k1" => v1 }

      mappings = [{ :k1, ["k1"], &Integer.to_string/1 }]

      transformed = Transformer.call(data, mappings)

      assert transformed.k1 == to_string(v1)
    end
  end

  #
  # private
  #

  defp gen_string() do
    Enum.random(["value1", "value2", "value3", "value"])
  end
end
