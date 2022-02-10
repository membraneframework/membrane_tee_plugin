defmodule Membrane.Tee.MixProject do
  use Mix.Project

  @version "0.7.0"
  @github_url "https://github.com/membraneframework/membrane_tee_plugin"

  def project do
    [
      app: :membrane_tee_plugin,
      version: @version,
      elixir: "~> 1.7",
      name: "Membrane Tee Plugin",
      description: "Plugin for splitting data from a single input to multiple outputs",
      package: package(),
      source_url: @github_url,
      docs: docs(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "LICENSE"],
      source_ref: "v#{@version}"
    ]
  end

  defp deps do
    [
      {:membrane_core, github: "membraneframework/membrane_core", tag: "v0.9.0-rc.0"},
      {:bunch, "~> 1.0"},
      {:ex_doc, "~> 0.26", only: :dev, runtime: false},
      {:dialyxir, "~> 1.1", only: :dev, runtime: false},
      {:credo, "~> 1.6.1", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Membrane Team"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => @github_url,
        "Membrane Framework Homepage" => "https://membraneframework.org"
      }
    ]
  end
end
