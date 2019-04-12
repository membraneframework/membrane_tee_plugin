# Membrane Multimedia Framework: Tee

This package provides elements that can be used to forward packets to multiple outputs.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `membrane_element_tee` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:membrane_element_tee, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [HexDocs](https://hexdocs.pm/membrane_element_tee).

## Example

Playing this pipeline should result in copying the source file to all destinations files (sinks)

```elixir
defmodule FileMultiForwardPipeline do
  use Membrane.Pipeline
  alias Pipeline.Spec
  alias Membrane.Element.File
  alias Membrane.Element.Tee

  @doc false
  @impl true
  def handle_init(_) do
    children = [
      file_src: %File.Source{location: "/tmp/sourceFile"},
      tee: Tee.Master,
      file_sink1: %File.Sink{location: "./destinationFile1"},
      file_sink2: %File.Sink{location: "./destinationFile2"},
    ]
    links = %{
      {:file_src, :output} => {:tee, :input},
      {:tee, :master} => {:file_sink1, :input},
      {:tee, :copy} => {:file_sink2, :input},
    }

    {{:ok, %Spec{children: children, links: links}}, %{}}
  end
end
```

Notice we use one `:master` pad which handles demands, and `:copy` pads which just forward same buffers to one or more sinks.

## Copyright and License

Copyright 2019, [Software Mansion](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=membrane)

[![Software Mansion](https://membraneframework.github.io/static/logo/swm_logo_readme.png)](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=membrane)

Licensed under the [Apache License, Version 2.0](LICENSE)
