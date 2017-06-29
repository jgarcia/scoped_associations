defmodule ScopedAssociations.HasMany do
  defmacro has_many_scoped name, options do
    include_func  = String.to_atom "include_#{name}"
    link_func     = String.to_atom "link_#{name}"
    load_func     = String.to_atom "load_#{name}"
    foreign_key   = String.to_atom options[:foreign_key]
    scope         = options[:scope]

    quote do
      def unquote(include_func)(source) do
        results = source
                  |> Enum.map(&(&1.id))
                  |> unquote(load_func)()

        source
        |> Enum.map(fn(p) -> unquote(link_func)(p, results) end)
      end

      defp unquote(load_func)(source_ids) do
        unquote(scope)()
        |> where([t], t.unquote(foreign_key)() in ^source_ids)
        |> @repo.all
      end

      defp unquote(link_func)(source, results) do
        results = Enum.filter(results,
                              fn(r) ->
                                r.unquote(foreign_key) == source.id
                              end)


        Map.put(source, unquote(name), results)
      end
    end
  end
end
