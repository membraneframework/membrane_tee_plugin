defmodule Membrane.Tee.CommonTest do
  @moduledoc false

  import ExUnit.Assertions

  @spec passes_received_buffers_to_all_pads(atom) :: :ok
  def passes_received_buffers_to_all_pads(tee) do
    buffer = %Membrane.Buffer{payload: 123}
    assert {actions, _state} = tee.handle_process(:input, buffer, nil, %{accepted_format: %{}})
    assert actions == [forward: buffer]
    :ok
  end

  @spec passes_received_stream_format_to_all_pads(atom) :: :ok
  def passes_received_stream_format_to_all_pads(tee) do
    stream_format = %{}

    assert {actions, _state} =
             tee.handle_stream_format(:input, stream_format, nil, %{accepted_format: nil})

    assert actions == [forward: stream_format]
    :ok
  end

  @spec sends_stream_format_when_new_output_pad_is_linked(atom, any) :: :ok
  def sends_stream_format_when_new_output_pad_is_linked(tee, output_pad) do
    stream_format = %{}

    assert {_actions, state} =
             tee.handle_stream_format(:input, stream_format, nil, %{accepted_format: nil})

    assert {actions, _state} = tee.handle_pad_added(output_pad, nil, state)
    assert actions == [stream_format: {output_pad, stream_format}]
    :ok
  end

  @spec does_not_send_nil_stream_format(atom, any) :: :ok
  def does_not_send_nil_stream_format(tee, output_pad) do
    assert {[], _state} = tee.handle_pad_added(output_pad, nil, %{accepted_format: nil})
    :ok
  end

  @spec passes_received_events_to_all_pads(atom) :: :ok
  def passes_received_events_to_all_pads(tee) do
    alias Membrane.Event.Discontinuity
    event = %Discontinuity{}
    assert {actions, _state} = tee.handle_event(:input, event, nil, %{accepted_format: :any})
    assert actions == [forward: event]
    :ok
  end
end
