defmodule Membrane.Tee.PushOutput do
  @moduledoc """
  Element forwarding packets to multiple push outputs.
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
    mode: :push,
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
