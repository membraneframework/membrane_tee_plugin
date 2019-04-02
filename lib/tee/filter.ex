defmodule Membrane.Element.Tee.Filter do
  use Membrane.Element.Base.Filter

  def_output_pads output: [
    caps: :any
  ]

  def_input_pads input: [
    caps: :any,
    demand_unit: :buffers
  ]

  @impl true
  def handle_process(_pad, _payload, _ctx, state) do
    {:ok, state}
  end

  @impl true
  def handle_demand(_output_pad, _size, _unit, _ctx, state) do
    {:ok, state}
  end
end
