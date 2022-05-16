defmodule Membrane.Tee.PushOutput do
  @moduledoc """
  Element forwarding packets to multiple push outputs.
  """
  use Membrane.Filter

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
  def handle_pad_added(Pad.ref(:output, _ref) = pad, _ctx, %{caps: caps} = state) do
    {{:ok, caps: {pad, caps}}, state}
  end

  @impl true
  def handle_process(:input, %Membrane.Buffer{} = buffer, _ctx, state) do
    {{:ok, forward: buffer}, state}
  end
end
