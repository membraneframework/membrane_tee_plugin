defmodule Membrane.Element.Tee.MixProject do
  use Mix.Project

  @version "0.1.0"
  @github_url "https://github.com/membraneframework/membrane-element-tee"

  def project do
    [
      app: :membrane_element_tee,
      version: @version,
      elixir: "~> 1.7",
      name: "Membrane Element Tee",
      description: "Membrane Multimedia Framework (Element Tee)",
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
      extras: ["README.md"],
      source_ref: "v#{@version}"
    ]
  end

  defp deps do
    [
      {:membrane_core, "~> 0.3.0"},
      {:bunch, "~> 1.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
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
