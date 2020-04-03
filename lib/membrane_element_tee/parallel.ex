defmodule Membrane.Element.Tee.Parallel do
  @moduledoc """
  Element for forwarding packets to multiple outputs.

  The processing speed is limited by the slowest consuming output.

  To use, link this element to one preceding element via `input` pad and multiple
  succesive elements via `output` pads. Each buffer is forwarded only when demand for
  it comes in via each output.
  """

  use Membrane.Filter

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
  def handle_demand(Pad.ref(:output, _id), _size, :buffers, ctx, state) do
    {{:ok, make_demands(ctx)}, state}
  end

  @impl true
  def handle_pad_removed(Pad.ref(:output, _id), %{playback_state: :playing} = ctx, state) do
    {{:ok, make_demands(ctx)}, state}
  end

  @impl true
  def handle_pad_removed(Pad.ref(:output, _id), _ctx, state) do
    {:ok, state}
  end

  defp make_demands(ctx) do
    minimal_size =
      ctx.pads
      |> Bunch.KVEnum.values()
      |> Enum.filter(&(&1.direction == :output))
      |> Enum.map(& &1.demand)
      |> Enum.min(fn -> 0 end)

    [demand: {:input, minimal_size}]
  end
end
