defmodule ScopedAssociations.Count do
  defmacro has_scoped_count name, options do
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
        |> group_by([t], t.unquote(foreign_key)())
        |> select([t], %{source_id: t.unquote(foreign_key)(), count: count(t.id)})
        |> @repo.all
      end

      defp unquote(link_func)(source, results) do
        result = results
                 |> Enum.find(%{count: 0}, fn(r) ->
                                   r.source_id == source.id
                                 end)

        Map.put(source, unquote(name), result.count)
      end
    end
  end
end
