defmodule TestPipeline do
  @moduledoc false
  use ExUnit.Case, async: true
  use Bunch

  import Membrane.Testing.Pipeline.Assertions

  alias Membrane.Buffer
  alias Membrane.Event.EndOfStream
  alias Membrane.Testing.Pipeline
  alias Membrane.Testing.Sink
  alias Membrane.Testing.DataSource

  def make_pipeline(data) do
    Pipeline.start_link(%Pipeline.Options{
      elements: [
        src: %DataSource{data: data},
        tee: Membrane.Element.Tee.Filter,
        sink1: %Sink{target: self()},
        sink2: %Sink{target: self()}
      ],
      monitored_callbacks: [:handle_notification],
      test_process: self(),
      links: %{
        {:src, :output} => {:tee, :input},
        {:tee, :output_static} => {:sink1, :input},
        {:tee, :output_dynamic} => {:sink2, :input}
      }
    })
  end

  test "forward input to two outputs" do
    range = 1..10
    assert {:ok, pid} = TestPipeline.make_pipeline(range)
    assert Pipeline.play(pid) == :ok
    # Wait for EndOfStream message on both sinks
    assert_receive_message({:handle_notification, {{:end_of_stream, :input}, :sink1}}, 3000)
    assert_receive_message({:handle_notification, {{:end_of_stream, :input}, :sink2}}, 3000)

    # assert every message was received twice
    Enum.each(range, fn element ->
      assert_receive %Buffer{payload: ^element}
      assert_receive %Buffer{payload: ^element}
    end)
  end
end
