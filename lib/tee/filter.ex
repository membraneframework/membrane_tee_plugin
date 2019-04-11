defmodule Membrane.Element.Tee.Filter do
  use Membrane.Element.Base.Filter

  def_input_pad :input,
    availability: :always,
    mode: :pull,
    demand_unit: :buffers,
    caps: :any

  def_output_pad :output_static,
    availability: :always,
    mode: :pull,
    caps: :any

  def_output_pad :output_dynamic,
    availability: :on_request,
    mode: :push,
    caps: :any

  defp pass_to_all_outputs(pads, action, value, state) do
    actions =
      pads
      |> Enum.filter(fn {_k, v} -> v.direction != :input end)
      |> Enum.map(fn {k, _v} -> {action, {k, value}} end)

    {{:ok, actions}, state}
  end

  @impl true
  def handle_process(:input, %Membrane.Buffer{} = buffer, ctx, state) do
    ctx.pads |> pass_to_all_outputs(:buffer, buffer, state)
  end

  @impl true
  def handle_caps(:input, caps, ctx, state) do
    ctx.pads |> pass_to_all_outputs(:caps, caps, state)
  end

  @impl true
  def handle_demand(:output_static, size, _unit, _ctx, state) do
    {{:ok, demand: {:input, size}}, state}
  end
end
