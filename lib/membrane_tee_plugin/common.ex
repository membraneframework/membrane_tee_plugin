defmodule Membrane.Tee.Common do
  @moduledoc false

  def handle_init(_opts) do
    {:ok, %{caps: nil}}
  end

  def handle_caps(_pad, caps, _ctx, state) do
    {{:ok, forward: caps}, %{state | caps: caps}}
  end

  def handle_pad_added(_pad, _ctx, %{caps: nil} = state) do
    {:ok, state}
  end

  def handle_pad_added(pad, _ctx, %{caps: caps} = state) do
    {{:ok, caps: {pad, caps}}, state}
  end

  def handle_process(_pad, buffer, _ctx, state) do
    {{:ok, forward: buffer}, state}
  end
end
