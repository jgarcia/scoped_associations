defmodule ScopedAssociations.TestApp do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(ScopedAssociations.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: ScopedAssociations.Supervisor]

    Supervisor.start_link(children, opts)
  end
end

