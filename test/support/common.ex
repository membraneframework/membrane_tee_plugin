defmodule Membrane.Tee.CommonTest do
  @moduledoc false

  import ExUnit.Assertions

  require Membrane.Pad

  alias Membrane.Pad

  @spec passes_received_buffers_to_all_pads(atom) :: :ok
  def passes_received_buffers_to_all_pads(tee) do
    buffer = %Membrane.Buffer{payload: 123}
    assert {actions, _state} = tee.handle_buffer(:input, buffer, nil, %{accepted_format: %{}})
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

    output_pads = [Pad.ref(:output, 0), Pad.ref(:output, 1)]

    # Since membrane_core 1.3.0 the default `Membrane.Filter.handle_event/4`
    # reads `context.pads[pad].direction` to forward the event to every pad of
    # the opposite direction, so a valid context with the input and output pads
    # has to be passed.
    context = %{
      pads:
        output_pads
        |> Map.new(&{&1, %{direction: :output}})
        |> Map.put(:input, %{direction: :input})
    }

    assert {actions, _state} =
             tee.handle_event(:input, event, context, %{accepted_format: :any})

    assert Enum.sort(actions) == Enum.sort(Enum.map(output_pads, &{:event, {&1, event}}))
    :ok
  end
end
