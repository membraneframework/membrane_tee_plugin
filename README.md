# Membrane Multimedia Framework: Tee

[![Hex.pm](https://img.shields.io/hexpm/v/membrane_element_tee.svg)](https://hex.pm/packages/membrane_element_tee)
[![CircleCI](https://circleci.com/gh/membraneframework/membrane-element-tee.svg?style=svg)](https://circleci.com/gh/membraneframework/membrane-element-tee)

This package provides elements that can be used to branch stream processing in pipeline, e.g. send data from one source to two or more sinks.

## Installation

This package can be installed by adding `membrane_element_tee` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:membrane_element_tee, "~> 0.1.0"}
  ]
end
```

The docs can be found at [HexDocs](https://hexdocs.pm/membrane_element_tee).

## Examples

### `Membrane.Element.Tee.Master`

This element has one `:master` output pad that dictates the speed of processing data
and dynamic `:copy` pad working in `:push` mode mirroring `:master` pad.

Playing this pipeline should result in copying the source file to all destination files (sinks).
Before playing it, make sure that the source file exists, e.g. like this:
`echo "Membrane Framework is cool" > /tmp/source_file`

You also need [`:membrane_element_file`](https://github.com/membraneframework/membrane-element-file) in project dependencies to run this pipeline.

```elixir
defmodule FileMultiForwardPipeline do
  use Membrane.Pipeline
  alias Pipeline.Spec
  alias Membrane.Element.{File, Tee}

  @impl true
  def handle_init(_) do
    children = [
      file_src: %File.Source{location: "/tmp/source_file"},
      tee: Tee.Master,
      file_sink1: %File.Sink{location: "/tmp/destination_file1"},
      file_sink2: %File.Sink{location: "/tmp/destination_file2"},
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

## Copyright and License

Copyright 2019, [Software Mansion](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=membrane-element-tee)

[![Software Mansion](https://membraneframework.github.io/static/logo/swm_logo_readme.png)](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=membrane-element-tee)

Licensed under the [Apache License, Version 2.0](LICENSE)
