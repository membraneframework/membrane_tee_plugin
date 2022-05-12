defmodule Membrane.Tee.MasterTest do
  use ExUnit.Case

  require Membrane.Pad

  alias Membrane.Pad
  alias Membrane.Tee.Master
  alias Membrane.Tee.CommonTest

  describe "Tee Master element" do
    test "passes received buffers to all pads" do
      CommonTest.passes_received_buffers_to_all_pads(Master)
    end

    test "passes received caps to all pads" do
      CommonTest.passes_received_caps_to_all_pads(Master)
    end

    test "sends caps when new output pad is linked" do
      CommonTest.sends_caps_when_new_output_pad_is_linked(Master, Pad.ref(:copy, make_ref()))
    end

    test "does not send nil caps when new output pad is linked before receiving caps from previous element" do
      CommonTest.does_not_send_nil_caps(Master, Pad.ref(:copy, make_ref()))
    end

    test "passes received events to all pads" do
      CommonTest.passes_received_events_to_all_pads(Master)
    end
  end
end
