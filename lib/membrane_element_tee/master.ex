defmodule Membrane.Element.Tee.Master do
  use Membrane.Filter

  @moduledoc """
  Element for forwarding packets to two or more outputs

  There is one input pad `:input` and 2 output pads:
  * `:master` - is a static pad which is always available and works in pull mode
  * `:copy` - is a dynamic pad which is available on demand and works in push mode

  Basically we can forward packets to more than one destination by linking dynamic pad to one or more inputs
  """

  def_input_pad :input,
    availability: :always,
    mode: :pull,
    demand_unit: :buffers,
    caps: :any

  def_output_pad :master,
    availability: :always,
    mode: :pull,
    caps: :any

  def_output_pad :copy,
    availability: :on_request,
    mode: :push,
    caps: :any

  @impl true
  def handle_process(:input, %Membrane.Buffer{} = buffer, _ctx, state) do
    {{:ok, forward: buffer}, state}
  end

  @impl true
  def handle_demand(:master, size, :buffers, _ctx, state) do
    {{:ok, demand: {:input, size}}, state}
  end
end
