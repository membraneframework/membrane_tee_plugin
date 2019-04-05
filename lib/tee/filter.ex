defmodule Membrane.Element.Tee.Filter do
  use Membrane.Element.Base.Filter

  def_input_pad :input,
    availability: :always,
    mode: :pull,
    demand_unit: :bytes,
    caps: :any,

  def_output_pad :output1,
    availability: :always,
    mode: :pull,
    caps: :any

  def_output_pad :output2,
    availability: :always,
    mode: :pull,
    caps: :any

  @impl true
  def handle_process(_pad, _payload, _ctx, state) do
    {:ok, state}
  end

  @impl true
  def handle_demand(_output_pad, _size, _unit, _ctx, state) do
    {:ok, state}

end
