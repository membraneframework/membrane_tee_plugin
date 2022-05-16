defmodule Membrane.Tee.Parallel do
  @moduledoc """
  Element for forwarding packets to multiple outputs.

  The processing speed is limited by the slowest consuming output.

  To use, link this element to one preceding element via `input` pad and multiple
  succesive elements via `output` pads. Each buffer is forwarded only when demand for
  it comes in via each output. If there are no outputs, buffers are dropped.
  """

  use Membrane.Filter

  def_input_pad :input,
    availability: :always,
    mode: :pull,
    demand_mode: :auto,
    caps: :any

  def_output_pad :output,
    availability: :on_request,
    mode: :pull,
    demand_mode: :auto,
    caps: :any

  @impl true
  def handle_init(_opts) do
    {:ok, %{caps: nil}}
  end

  @impl true
  def handle_caps(_pad, caps, _ctx, state) do
    {{:ok, forward: caps}, %{state | caps: caps}}
  end

  @impl true
  def handle_pad_added(Pad.ref(:output, _ref), _ctx, %{caps: nil} = state) do
    {:ok, state}
  end

  @impl true
  def handle_pad_added(pad, _ctx, %{caps: caps} = state) do
    {{:ok, caps: {pad, caps}}, state}
  end

  @impl true
  def handle_process(:input, %Membrane.Buffer{} = buffer, _ctx, state) do
    {{:ok, forward: buffer}, state}
  end
end
