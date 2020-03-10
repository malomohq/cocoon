# Cocoon

**Cocoon** is a pure [Elixir](http://elixir-lang.org/) library for transforming data 🐛✨🦋

## Installation

Cocoon is published on [Hex](https://hex.pm/packages/cocoon).
Add it to your list of dependencies in `mix.exs`;

```elixir
defp deps do
  { :cocoon, "~> 1.0" }
end
```

## Usage

Pass a map-based dataset into `Cocoon.transform/2`, along with a list of a
mappings, and it will emerge in a new form:

```elixir
data =
  %{
    "currency" => "USD",
    "customer" => %{
      "email" => "rodserling@example.com",
    },
    "notifications" => false,
    "number_of_items" => 3,
    "order_number" => 12
  }

mappings =
  [
    { :currency, ["currency"] },
    { :email, ["customer", "email"] },
    { :item_count, ["number_of_items"] },
    { :number, ["order_number"], &to_string/1 }
  ]

Cocoon.transform(data, mappings)
#=> %{
#=>   currency: "USD",
#=>   email: "rodserling@example.com",
#=>   item_count: 3,
#=>   number: "12"
#=> }
```

One potential use case for Cocoon is to serve as a transformation layer between
the outside world and your application.

For example, you might transform the responses from an external API into a
format that is more predictable and consistent with the vocabulary in your app.
By doing this, you also impose a boundary that limits coupling to the external 
data source.

### Mappings

Cocoon transforms data by using a set of user-specified mappings, i.e. a list
of instructions for how individual elements in the dataset should be changed.

A mapping can be either a 2 or 3-element tuple, corresponding to a specific
entry in the dataset:

* First element - destination key, i.e. "to key"
* Second element - path to existing key, i.e. "from key(s)"
* Third element (optional) - function to apply to value at existing key

_NOTE: A mapping must be provided for every key / value pair that you want to
be returned. In other words, the transformed dataset will only contain key /
value pairs that are explicitly defined by a mapping._

### Data Types

Cocoon currently provides support for transforming maps, or a list of maps of
the same kind, e.g. a list of orders.

If a list of maps is provided, a list of maps will also be returned, with the mappings applied to each element of the set.
