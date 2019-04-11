defmodule TestPipeline do
  @moduledoc false
  use ExUnit.Case, async: true
  use Bunch

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
      test_process: self(),
      links: %{
        {:src, :output} => {:tee, :input},
        {:tee, :output_static} => {:sink1, :input},
        {:tee, :output_dynamic} => {:sink2, :input}
      }
    })
  end

  # def generator_from_data(data) do
  #   actions = Enum.map(data, fn element -> {:buffer, {:output, %Buffer{payload: element}}} end)

  #   fn cnt, size ->
  #     if(cnt != 0, do: cnt, else: actions)
  #     |> Enum.split(size)
  #     ~>> ({to_send, []} -> {to_send ++ [{:event, {:output, %EndOfStream{}}}], []})
  #   end
  # end

  test "forward input to two outputs" do
    range = 1..10 |> Enum.to_list()
    assert {:ok, pid} = TestPipeline.make_pipeline(range)
    assert Pipeline.play(pid) == :ok

    # asset end of stream

    Enum.each(range, fn element ->
      assert_receive %Buffer{payload: ^element}
      assert_receive %Buffer{payload: ^element}
    end)
  end
end
