defmodule Membrane.Tee.MasterTest do
  use ExUnit.Case

  alias Membrane.Tee.Master

  describe "Tee Master element" do
    test "passes received buffers to all pads" do
      buffer = %Membrane.Buffer{payload: 123}
      assert {{:ok, actions}, _state} = Master.handle_process(:input, buffer, nil, %{})
      assert actions == [forward: buffer]
    end

    test "passes received caps to all pads" do
      cap = %{}
      assert {{:ok, actions}, _state} = Master.handle_caps(:input, cap, nil, %{})
      assert actions == [forward: cap]
    end

    test "passes received events to all pads" do
      alias Membrane.Event.Discontinuity
      event = %Discontinuity{}
      assert {{:ok, actions}, _state} = Master.handle_event(:input, event, nil, %{})
      assert actions == [forward: event]
    end
  end
end
