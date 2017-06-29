# ScopedAssociations

A very simple macro to implement scoped associations in your schemas.


## Installation

The package can be installed by adding `scoped_associations`
to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:scoped_associations, github: "jgarcia/scoped_associations", app: false}]
end
```

## Usage

Consider the following schema.

```elixir
defmodule Customer do
  ...
  schema "customers" do
    ...
    has_many :purchases, Purchase
    has_many :reviews, Review
    ...
  end
end
```

Supose that in a page you want to display the customer's last purchase and
first review.

Modifying your schema like this 

```elixir
defmodule Customer do
  ...
  use ScopedAssociations

  schema "customers" do
    ...
  end

  has_one_scoped :last_purchase, schema: Purchase, foreign_key: "customer_id", scope: :last_purchase
  has_one_scoped :first_review, schema: Review, foreign_key: "customer_id", scope: :first_review

  def last_purchase do
    from p in Purchase,
      join: f in fragment("SELECT MAX(id) AS id, customer_id FROM purchases GROUP BY customer_id"),
      on: p.id == f.id
  end

  def first_review do
    from r in Review,
      join: f in fragment("SELECT MIN(id) AS id, customer_id FROM reviews GROUP BY customer_id"),
      on: r.id == f.id
  end
end
```

To load those relations you can use the include function along with list of relations to load

```elixir
customers = Repo.all(Customer)
            |> Customer.include([:last_purchase, :first_review])
```

## Notes

Please keep in mind that this is a first draft, there is some code duplication
that I will address in the near future as well as some improvements to the api.

## Todo

- [ ] Add tests with ecto schemas
- [ ] Remove code duplication in favor of reusable functions to reduce the number functions defined by the macro
- [ ] Figure out some edge cases
- [ ] Publish in hex
