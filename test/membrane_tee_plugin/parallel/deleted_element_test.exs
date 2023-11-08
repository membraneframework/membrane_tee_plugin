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
    def handle_init(_ctx, data) do
      links = [
        child(:tee, Membrane.Tee.Parallel),
        child(:src, %Source{output: data}) |> get_child(:tee) |> child(:sink1, %Sink{}),
        get_child(:tee) |> child(:sink2, %Sink{})
      ]

      {[spec: links], %{}}
    end
  end

  @spec make_pipeline(Membrane.Pipeline.pipeline_options_t()) :: GenServer.on_start()
  def make_pipeline(data) do
    Pipeline.start_link(module: Pipe, custom_args: data)
  end

  test "delete sink1" do
    range = 1..100
    assert {:ok, _supervisior_pid, pid} = make_pipeline(range)

    # remove element sink1
    send(pid, {:delete, :sink1})

    assert_end_of_stream(pid, :sink2, :input, 3000)

    Enum.each(range, fn element ->
      assert_sink_buffer(pid, :sink2, %Buffer{payload: ^element})
    end)

    Pipeline.terminate(pid)
  end
end
