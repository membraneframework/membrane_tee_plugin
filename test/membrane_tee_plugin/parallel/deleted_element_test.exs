defmodule Membrane.Tee.DeletedElementTest do
  @moduledoc false
  use ExUnit.Case, async: true
  use Bunch

  import Membrane.Testing.Assertions

  alias Membrane.Buffer
  alias Membrane.Testing.{Pipeline, Sink, Source}

  defmodule Pipe do
    use Membrane.Pipeline

    @impl true
    def handle_init(data) do
      children = [
        src: %Source{output: data},
        tee: Membrane.Tee.Parallel,
        sink1: %Sink{},
        sink2: %Sink{}
      ]

      links = [
        link(:src) |> to(:tee) |> to(:sink1),
        link(:tee) |> to(:sink2)
      ]

      spec = %ParentSpec{
        children: children,
        links: links
      }

      {{:ok, spec: spec}, %{}}
    end
  end

  def make_pipeline(data) do
    Pipeline.start_link(module: Pipe, custom_args: data)
  end

  test "delete sink1" do
    range = 1..100
    assert {:ok, pid} = make_pipeline(range)
    Pipeline.execute_actions(pid, playback: :stopped)

    # remove element sink1
    send(pid, {:delete, :sink1})

    Pipeline.execute_actions(pid, playback: :playing)
    Pipeline.execute_actions(pid, playback: :playing)

    assert_end_of_stream(pid, :sink2, :input, 3000)

    Enum.each(range, fn element ->
      assert_sink_buffer(pid, :sink2, %Buffer{payload: ^element})
    end)

    Pipeline.terminate(pid, blocking?: true)
  end
end
