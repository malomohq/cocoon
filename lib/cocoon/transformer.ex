defmodule Cocoon.Transformer do
  alias Cocoon.{ Mapping }

  @spec call(map | [map], [Mapping.t()]) :: map | [map]
  def call(data, mappings)
  def call(data, mappings) when is_list(data) do
    Enum.map(data, &(call(&1, mappings)))
  end

  def call(data, mappings) do
    Enum.reduce(mappings, %{}, fn
      ({ to, from }, acc) ->
        Map.put(acc, to, get_in(data, from))
      ({ to, from, function }, acc) ->
        Map.put(acc, to, transform(get_in(data, from), function))
    end)
  end

  #
  # private
  #

  defp transform(nil, _function) do
    nil
  end

  defp transform(value, function) do
    function.(value)
  end
end
