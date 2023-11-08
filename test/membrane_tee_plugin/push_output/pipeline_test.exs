defmodule Membrane.Tee.PushOutput.PipelineTest do
  @moduledoc false
  use ExUnit.Case, async: true
  use Bunch

  import Membrane.Testing.Assertions

  alias Membrane.Buffer
  alias Membrane.Testing.{Pipeline, Sink, Source}

  @spec make_pipeline(Enumerable.t()) :: GenServer.on_start()
  def make_pipeline(data) do
    import Membrane.ChildrenSpec

    Pipeline.start_link(
      spec: [
        child(:tee, Membrane.Tee.PushOutput),
        child(:src, %Source{output: data}) |> get_child(:tee) |> child(:sink1, %Sink{}),
        get_child(:tee) |> child(:sink2, %Sink{}),
        get_child(:tee) |> child(:sink3, %Sink{})
      ]
    )
  end

  test "forward input to three outputs" do
    range = 1..100
    assert {:ok, _supervised_pid, pid} = make_pipeline(range)

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

    Pipeline.terminate(pid)
  end
end
