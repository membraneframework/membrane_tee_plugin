defmodule Membrane.Element.Tee.MixProject do
  use Mix.Project

  @version "0.1.0"
  @github_url "https://github.com/membraneframework/membrane-element-tee"

  def project do
    [
      app: :membrane_element_tee,
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      source_url: @github_url,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:membrane_core, "~> 0.3.0"}
    ]
  end
end
