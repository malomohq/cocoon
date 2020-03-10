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
      "email_address" => "rodserling@example.com",
      "name" => "Rod Serling"
    }
    "notifications" => false,
    "order_number" => 12
  }

mappings =
  [
    { :currency, ["currency"] },
    { :email, ["customer", "email_address"] },
    { :name, ["customer", "name"] },
    { :number, "order_count", &to_string/1 }
  ]

Cocoon.transform(data, mappings)
#=> %{
#=>   currency: "USD",
#=>   email: "rodserling@example.com",
#=>   name: "Rod Serling",
#=>   number: "12"
#=> }
```

### Mappings

Cocoon transforms data by using a set of user-specified mappings, i.e. a list
of instructions for how individual elements in the dataset should be changed.

A mapping can be either a 2 or 3-element tuple, corresponding to a specific
entry in the dataset:

* First element - destination key, i.e. "to key"
* Second element - path to existing key, i.e. "from key(s)"
* Third element (optional) - function to apply to value at existing key

### Data Types

Cocoon currently provides support for transforming maps, or a list of maps of
the same kind, e.g. a list of orders.
