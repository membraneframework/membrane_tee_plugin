defmodule Membrane.Tee.Master do
  @moduledoc """
  Element for forwarding buffers to at least one output pad

  It has one input pad `:input` and 2 output pads:
  * `:master` - is a static pad which is always available and works in pull mode
  * `:copy` - is a dynamic pad that can be linked to any number of elements (including 0) and works in push mode

  The `:master` pad dictates the speed of processing data and any element (or elements) connected to `:copy` pad
  will receive the same data as `:master`
  """
  use Membrane.Filter

  alias Membrane.Tee.Common

  def_input_pad :input,
    availability: :always,
    demand_mode: :auto,
    caps: :any

  def_output_pad :master,
    availability: :always,
    demand_mode: :auto,
    caps: :any

  def_output_pad :copy,
    availability: :on_request,
    mode: :push,
    caps: :any

  @impl true
  def handle_init(opts), do: Common.handle_init(opts)

  @impl true
  def handle_caps(pad, caps, ctx, state), do: Common.handle_caps(pad, caps, ctx, state)

  @impl true
  def handle_pad_added(Pad.ref(:copy, _ref) = pad, ctx, state),
    do: Common.handle_pad_added(pad, ctx, state)

  @impl true
  def handle_process(:input = pad, %Membrane.Buffer{} = buffer, ctx, state),
    do: Common.handle_process(pad, buffer, ctx, state)
end
