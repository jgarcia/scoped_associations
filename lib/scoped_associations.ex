defmodule ScopedAssociations do
  @moduledoc """
  Documentation for ScopedAssociations.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ScopedAssociations.hello
      :world

  """
  defmacro __using__(options) do
    quote do
      import unquote(__MODULE__)
      import ScopedAssociations.HasMany
      import ScopedAssociations.HasOne
      @repo unquote(options)[:repo]

      def include(source, associations) do
        associations
        |> Enum.reduce(source, fn(assoc, acc) ->
                         apply(__MODULE__, String.to_atom("include_#{assoc}"), [acc])
                       end)
      end
    end
  end
end