defmodule Membrane.Tee.MasterTest do
  use ExUnit.Case

  require Membrane.Pad

  alias Membrane.Pad
  alias Membrane.Tee.CommonTest
  alias Membrane.Tee.Master

  describe "Tee Master element" do
    test "passes received buffers to all pads" do
      CommonTest.passes_received_buffers_to_all_pads(Master)
    end

    test "passes received stream_format to all pads" do
      CommonTest.passes_received_stream_format_to_all_pads(Master)
    end

    test "sends stream_format when new output pad is linked" do
      CommonTest.sends_stream_format_when_new_output_pad_is_linked(
        Master,
        Pad.ref(:copy, make_ref())
      )
    end

    test "does not send nil stream_format when new output pad is linked before receiving stream_format from previous element" do
      CommonTest.does_not_send_nil_stream_format(Master, Pad.ref(:copy, make_ref()))
    end

    test "passes received events to all pads" do
      CommonTest.passes_received_events_to_all_pads(Master)
    end
  end
end
