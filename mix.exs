defmodule ScopedAssociations.Mixfile do
  use Mix.Project

  def project do
    [app: :scoped_associations,
     version: "0.1.0",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    application_load_config(Mix.env)
  end

  # Application configuration
  defp application_load_config(:test) do
    [mod: {ScopedAssociations.TestApp, []},
     extra_applications: [:logger]]
  end

  defp application_load_config(_) do
    [extra_applications: [:logger]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:postgrex, ">= 0.0.0"},
     {:ecto, "~> 2.1"}]
  end
end
