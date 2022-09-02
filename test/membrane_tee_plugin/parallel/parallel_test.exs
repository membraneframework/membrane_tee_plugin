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

    test "passes received caps to all pads" do
      CommonTest.passes_received_caps_to_all_pads(Parallel)
    end

    test "sends caps when new output pad is linked" do
      CommonTest.sends_caps_when_new_output_pad_is_linked(Parallel, Pad.ref(:output, make_ref()))
    end

    test "does not send nil caps when new output pad is linked before receiving caps from previous element" do
      CommonTest.does_not_send_nil_caps(Parallel, Pad.ref(:output, make_ref()))
    end

    test "passes received events to all pads" do
      CommonTest.passes_received_events_to_all_pads(Parallel)
    end
  end
end
