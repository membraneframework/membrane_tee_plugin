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
  def handle_process(:input, %Membrane.Buffer{} = buffer, _ctx, state) do
    {{:ok, forward: buffer}, state}
  end
end
