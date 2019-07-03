defmodule Membrane.Element.Tee.Parallel do
  use Membrane.Element.Base.Filter

  @moduledoc """
  Element for forwarding packets to two or more outputs

  There is one input pad `:input` and output pad:

  * `:output` - is a dynamic pad which is available on request and works in pull mode

  Basically we can forward packets to more than one destination by linking dynamic pad to one or more inputs. Packets are forwarded only when all output pads send demands.
  To avoid overriding your links to output pads, create them with specific id ({:tee, :output, id})
  """

  def_input_pad :input,
    availability: :always,
    mode: :pull,
    demand_unit: :buffers,
    caps: :any

  def_output_pad :output,
    availability: :on_request,
    mode: :pull,
    caps: :any

  @impl true
  def handle_init(_) do
    state = %{}
    {:ok, state}
  end

  @impl true
  def handle_process(:input, %Membrane.Buffer{} = buffer, _ctx, state) do
    {{:ok, forward: buffer}, state}
  end

  @impl true
  def handle_demand({:dynamic, type, id}, size, :buffers, ctx, state) do
    state = Map.put(state, {type, id}, size)
    check_number_of_demands(ctx, state)
  end

  defp check_number_of_demands(ctx, state) do
    if map_size(state) == map_size(ctx.pads) - 1 do
      minimal_size = Enum.reduce(Map.values(state), &min/2)
      state = %{}
      {{:ok, demand: {:input, minimal_size}}, state}
    else
      {:ok, state}
    end
  end

  @impl true
  def handle_pad_removed({:dynamic, type, id}, ctx, state) do
    state = Map.drop(state, [{type, id}])
    check_number_of_demands(ctx, state)
  end
end
