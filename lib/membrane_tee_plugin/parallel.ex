defmodule Membrane.Tee.Parallel do
  @moduledoc """
  Element for forwarding packets to multiple outputs.

  The processing speed is limited by the slowest consuming output.

  To use, link this element to one preceding element via `input` pad and multiple
  succesive elements via `output` pads. Each buffer is forwarded only when demand for
  it comes in via each output. If there are no outputs, buffers are dropped.
  """

  use Membrane.Filter

  alias Membrane.Tee.Common

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
  def handle_init(opts), do: Common.handle_init(opts)

  @impl true
  def handle_caps(pad, caps, ctx, state), do: Common.handle_caps(pad, caps, ctx, state)

  @impl true
  def handle_pad_added(Pad.ref(:output, _ref) = pad, ctx, state),
    do: Common.handle_pad_added(pad, ctx, state)

  @impl true
  def handle_process(:input = pad, %Membrane.Buffer{} = buffer, ctx, state),
    do: Common.handle_process(pad, buffer, ctx, state)
end
