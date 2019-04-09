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

  # TODO: extract pads mapping to separate function
  @impl true
  def handle_process(:input, %Membrane.Buffer{} = buffer, ctx, state) do
    {{:ok,
      ctx.pads
      |> Enum.filter(fn {_k, v} -> v.direction != :input end)
      |> Enum.map(fn {k, _v} -> {:buffer, {k, buffer}} end)}, state}
  end

  @impl true
  def handle_event(:input, event, ctx, state) do
    {{:ok,
      ctx.pads
      |> Enum.filter(fn {_k, v} -> v.direction != :input end)
      |> Enum.map(fn {k, _v} -> {:event, {k, event}} end)}, state}
  end

  @impl true
  def handle_caps(:input, caps, ctx, state) do
    {{:ok,
      ctx.pads
      |> Enum.filter(fn {_k, v} -> v.direction != :input end)
      |> Enum.map(fn {k, _v} -> {:caps, {k, caps}} end)}, state}
  end

  @impl true
  def handle_demand(:output_static, size, _unit, _ctx, state) do
    {{:ok, demand: {:input, size}}, state}
  end
end
