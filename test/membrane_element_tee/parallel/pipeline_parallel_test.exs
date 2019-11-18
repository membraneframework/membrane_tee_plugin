defmodule Membrane.Element.Tee.PipelineParallelTest do
  @moduledoc false
  use ExUnit.Case, async: true
  use Bunch

  import Membrane.Testing.Assertions

  alias Membrane.Buffer
  alias Membrane.Testing.{Source, Pipeline, Sink}

  def make_pipeline(data) do
    import Membrane.ParentSpec

    Pipeline.start_link(%Pipeline.Options{
      elements: [
        src: %Source{output: data},
        tee: Membrane.Element.Tee.Parallel,
        sink1: %Sink{},
        sink2: %Sink{},
        sink3: %Sink{}
      ],
      links: [
        link(:src) |> to(:tee) |> to(:sink1),
        link(:tee) |> to(:sink2),
        link(:tee) |> to(:sink3)
      ]
    })
  end

  test "forward input to three outputs" do
    range = 1..100
    assert {:ok, pid} = make_pipeline(range)
    assert Pipeline.play(pid) == :ok

    # Wait for EndOfStream message on every sink
    assert_end_of_stream(pid, :sink1, :input, 3000)
    assert_end_of_stream(pid, :sink2, :input, 3000)
    assert_end_of_stream(pid, :sink3, :input, 3000)

    # assert every message was received three times
    Enum.each(range, fn element ->
      assert_sink_buffer(pid, :sink1, %Buffer{payload: ^element})
      assert_sink_buffer(pid, :sink2, %Buffer{payload: ^element})
      assert_sink_buffer(pid, :sink3, %Buffer{payload: ^element})
    end)
  end
end
