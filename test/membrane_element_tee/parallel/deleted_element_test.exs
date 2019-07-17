defmodule Membrane.Element.Tee.DeletedElementTest do
  @moduledoc false
  use ExUnit.Case, async: true
  use Bunch

  import Membrane.Testing.Assertions

  alias Membrane.Buffer
  alias Membrane.Testing.{Source, Pipeline, Sink}

  defmodule Pipe do
    def handle_init(data) do
      children = [
        src: %Source{output: data},
        tee: Membrane.Element.Tee.Parallel,
        sink1: %Sink{},
        sink2: %Sink{}
      ]

      links = %{
        {:src, :output} => {:tee, :input},
        {:tee, :output, 1} => {:sink1, :input},
        {:tee, :output, 2} => {:sink2, :input}
      }

      spec = %Membrane.Pipeline.Spec{
        children: children,
        links: links
      }

      {{:ok, spec}, %{}}
    end

    def handle_spec_started(_elements, state),
      do: {:ok, state}

    def handle_stopped_to_prepared(state),
      do: {:ok, state}

    def handle_playing_to_prepared(state),
      do: {:ok, state}

    def handle_playing_to_stopped(state),
      do: {:ok, state}

    def handle_prepared_to_stopped(state),
      do: {:ok, state}

    def handle_prepared_to_playing(state),
      do: {:ok, state}

    def handle_notification(_, _, state),
      do: {:ok, state}

    def handle_other({:delete, name}, state),
      do: {{:ok, remove_child: name}, state}

    def handle_other(_, state),
      do: {:ok, state}
  end

  def make_pipeline(data) do
    Pipeline.start_link(%Pipeline.Options{
      module: Pipe,
      custom_args: data
    })
  end

  test "delete sink1" do
    range = 1..100
    assert {:ok, pid} = make_pipeline(range)
    assert Pipeline.play(pid) == :ok
    Pipeline.stop(pid)

    # remove element sink1
    send(pid, {:delete, :sink1})

    Pipeline.play(pid)
    assert Pipeline.play(pid) == :ok

    assert_end_of_stream(pid, :sink2, :input, 3000)

    Enum.each(range, fn element ->
      assert_sink_buffer(pid, :sink2, %Buffer{payload: ^element})
    end)
  end
end
