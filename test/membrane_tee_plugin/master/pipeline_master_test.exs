defmodule Membrane.Tee.PipelineMasterTest do
  @moduledoc false
  use ExUnit.Case
  use Bunch

  import Membrane.Testing.Assertions

  alias Membrane.Buffer
  alias Membrane.Testing.{Pipeline, Sink, Source}

  @spec make_pipeline(Enumerable.t()) :: GenServer.on_start()
  def make_pipeline(data) do
    import Membrane.ChildrenSpec

    Pipeline.start_link(
      structure: [
        child(:tee, Membrane.Tee.Master),
        child(:src, %Source{output: data})
        |> get_child(:tee)
        |> via_out(:master)
        |> child(:sink1, %Sink{}),
        get_child(:tee) |> via_out(:copy) |> child(:sink2, %Sink{})
      ]
    )
  end

  test "forward input to two outputs" do
    range = 1..100
    assert {:ok, _supervisor_pid, pid} = make_pipeline(range)

    # Wait for EndOfStream message on both sinks
    assert_end_of_stream(pid, :sink1, :input, 3000)
    assert_end_of_stream(pid, :sink2, :input, 3000)

    # assert every message was received twice
    Enum.each(range, fn element ->
      assert_sink_buffer(pid, :sink1, %Buffer{payload: ^element})
      assert_sink_buffer(pid, :sink2, %Buffer{payload: ^element})
    end)

    Pipeline.terminate(pid, blocking?: true)
  end
end
