defmodule Membrane.Tee.ParallelTest do
  use ExUnit.Case

  require Membrane.Pad

  alias Membrane.Pad
  alias Membrane.Tee.CommonTest
  alias Membrane.Tee.Parallel

  describe "Tee Parallel element" do
    test "passes received buffers to all pads" do
      CommonTest.passes_received_buffers_to_all_pads(Parallel)
    end

    test "passes received stream_format to all pads" do
      CommonTest.passes_received_stream_format_to_all_pads(Parallel)
    end

    test "sends stream_format when new output pad is linked" do
      CommonTest.sends_stream_format_when_new_output_pad_is_linked(
        Parallel,
        Pad.ref(:output, make_ref())
      )
    end

    test "does not send nil stream_format when new output pad is linked before receiving stream_format from previous element" do
      CommonTest.does_not_send_nil_stream_format(Parallel, Pad.ref(:output, make_ref()))
    end

    test "passes received events to all pads" do
      CommonTest.passes_received_events_to_all_pads(Parallel)
    end
  end
end
