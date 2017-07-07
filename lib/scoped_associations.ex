defmodule ScopedAssociations do
  @moduledoc """
  Documentation for ScopedAssociations.
  """

  defmacro __using__(options) do
    quote do
      import unquote(__MODULE__)
      import ScopedAssociations.HasMany
      import ScopedAssociations.HasOne
      import ScopedAssociations.Count
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
