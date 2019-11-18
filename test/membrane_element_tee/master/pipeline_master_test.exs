defmodule Membrane.Element.Tee.PipelineMasterTest do
  @moduledoc false
  use ExUnit.Case
  use Bunch

  import Membrane.Testing.Assertions

  alias Membrane.Buffer
  alias Membrane.Testing.{Source, Pipeline, Sink}

  def make_pipeline(data) do
    import Membrane.ParentSpec

    Pipeline.start_link(%Pipeline.Options{
      elements: [
        src: %Source{output: data},
        tee: Membrane.Element.Tee.Master,
        sink1: %Sink{},
        sink2: %Sink{}
      ],
      links: [
        link(:src) |> to(:tee) |> via_out(:master) |> to(:sink1),
        link(:tee) |> via_out(:copy) |> to(:sink2)
      ]
    })
  end

  test "forward input to two outputs" do
    range = 1..100
    assert {:ok, pid} = make_pipeline(range)
    assert Pipeline.play(pid) == :ok

    # Wait for EndOfStream message on both sinks
    assert_end_of_stream(pid, :sink1, :input, 3000)
    assert_end_of_stream(pid, :sink2, :input, 3000)

    # assert every message was received twice
    Enum.each(range, fn element ->
      assert_sink_buffer(pid, :sink1, %Buffer{payload: ^element})
      assert_sink_buffer(pid, :sink2, %Buffer{payload: ^element})
    end)
  end
end
