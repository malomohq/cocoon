defmodule Cocoon do
  alias Cocoon.{ Transformer }

  @doc """
  Transforms data.

  ## Arguments

  * `:data` - map or list of maps to transform
  * `:mappings` - list of tuple mappings

  ## Examples

    data = %{ "key" => "value" }
    mappings = [{ :key, ["key"] }]

    %{ key: "value" } = Cocoon.transform(data, mappings)

    data = %{ "key" => 7 }
    mappings = [{ :key, ["key"], &to_string/1 }]

    %{ key: "7" } = Cocoon.transform(data, mappings)
  """
  defdelegate transform(data, mappings), to: Transformer, as: :call
end
