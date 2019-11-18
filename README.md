# Membrane Multimedia Framework: Tee

[![Hex.pm](https://img.shields.io/hexpm/v/membrane_element_tee.svg)](https://hex.pm/packages/membrane_element_tee)
[![CircleCI](https://circleci.com/gh/membraneframework/membrane-element-tee.svg?style=svg)](https://circleci.com/gh/membraneframework/membrane-element-tee)

This package provides elements that can be used to branch stream processing in pipeline, e.g. send data from one source to two or more sinks.

## Installation

This package can be installed by adding `membrane_element_tee` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:membrane_element_tee, "~> 0.3.0"}
  ]
end
```

The docs can be found at [HexDocs](https://hexdocs.pm/membrane_element_tee).

## Examples

### `Membrane.Element.Tee.Parallel`

This element has dynamic `:output` pads working in `:pull` mode. Packets are forwarded
only when all output pads send demands, which means that the slowest output pad dictates
the speed of processing data.

Playing this pipeline should result in copying the source file to all destination files (sinks).
Before playing it, make sure that the source file exists, e.g. like this:
`echo "Membrane Framework is cool" > /tmp/source_text_file`

You also need [`:membrane_element_file`](https://github.com/membraneframework/membrane-element-file) in project dependencies to run this pipeline.

```elixir
defmodule FileMultiForwardPipeline do
  use Membrane.Pipeline
  alias Membrane.Element.{File, Tee}

  @impl true
  def handle_init(_) do
    children = [
      file_src: %File.Source{location: "tmp/source_text_file"},
      tee: Tee.Parallel,
      file_sink1: %File.Sink{location: "/tmp/destination_file1"},
      file_sink2: %File.Sink{location: "/tmp/destination_file2"},
    ]
    links = [
      link(:file_src) |> to(:tee) |> to(:file_sink1),
      link(:tee) |> to(:file_sink2)
    ]

    {{:ok, %ParentSpec{children: children, links: links}}, %{}}
  end
end
```

### `Membrane.Element.Tee.Master`

This element has one `:master` output pad that dictates the speed of processing data
and dynamic `:copy` pad working in `:push` mode mirroring `:master` pad.

Playing this pipeline should result in playing mp3 source file and copying it to the destination file.
Before playing it, make sure you have valid source file, e.g. [this one](https://github.com/membraneframework/membrane-demo/blob/v0.3/sample.mp3).

You also need [`:membrane_element_file`](https://github.com/membraneframework/membrane-element-file) and [`:membrane_element_portaudio`](https://github.com/membraneframework/membrane-element-portaudio) in project dependencies to run this pipeline.

```elixir
defmodule AudioPlayAndCopyPipeline do
  use Membrane.Pipeline
  alias Membrane.Element.{File, Tee, PortAudio}

  @impl true
  def handle_init(_) do
    children = [
      file_src: %File.Source{location: "/tmp/source_file.mp3"},
      tee: Tee.Master,
      audio_sink: Membrane.Element.PortAudio.Sink,
      file_sink: %File.Sink{location: "/tmp/destination_file.mp3"},
    ]
    links = [
      link(:file_src) |> to(:tee),
      link(:tee) |> via_out(:master) |> to(:audio_sink),
      link(:tee) |> via_out(:copy) |> to(:file_sink)
    ]

    {{:ok, %ParentSpec{children: children, links: links}}, %{}}
  end
end
```

## Copyright and License

Copyright 2019, [Software Mansion](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=membrane-element-tee)

[![Software Mansion](https://membraneframework.github.io/static/logo/swm_logo_readme.png)](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=membrane-element-tee)

Licensed under the [Apache License, Version 2.0](LICENSE)
