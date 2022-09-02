defmodule Membrane.Tee.CommonTest do
  @moduledoc false

  import ExUnit.Assertions

  @spec passes_received_buffers_to_all_pads(atom) :: :ok
  def passes_received_buffers_to_all_pads(tee) do
    buffer = %Membrane.Buffer{payload: 123}
    assert {{:ok, actions}, _state} = tee.handle_process(:input, buffer, nil, %{caps: %{}})
    assert actions == [forward: buffer]
    :ok
  end

  @spec passes_received_caps_to_all_pads(atom) :: :ok
  def passes_received_caps_to_all_pads(tee) do
    caps = %{}
    assert {{:ok, actions}, _state} = tee.handle_caps(:input, caps, nil, %{caps: nil})
    assert actions == [forward: caps]
    :ok
  end

  @spec sends_caps_when_new_output_pad_is_linked(atom, any) :: :ok
  def sends_caps_when_new_output_pad_is_linked(tee, output_pad) do
    caps = %{}
    assert {{:ok, _actions}, state} = tee.handle_caps(:input, caps, nil, %{caps: nil})
    assert {{:ok, actions}, _state} = tee.handle_pad_added(output_pad, nil, state)
    assert actions == [caps: {output_pad, caps}]
    :ok
  end

  @spec does_not_send_nil_caps(atom, any) :: :ok
  def does_not_send_nil_caps(tee, output_pad) do
    assert {:ok, _state} = tee.handle_pad_added(output_pad, nil, %{caps: nil})
    :ok
  end

  @spec passes_received_events_to_all_pads(atom) :: :ok
  def passes_received_events_to_all_pads(tee) do
    alias Membrane.Event.Discontinuity
    event = %Discontinuity{}
    assert {{:ok, actions}, _state} = tee.handle_event(:input, event, nil, %{caps: :any})
    assert actions == [forward: event]
    :ok
  end
end
