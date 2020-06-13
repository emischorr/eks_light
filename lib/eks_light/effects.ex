defmodule EksLight.Effects do
  def set_color(%{count: count} = state, color) do
    Enum.each(0..count, fn(x) ->
      Blinkchain.set_pixel(%Blinkchain.Point{x: x, y: 0}, Blinkchain.Color.parse(color))
    end)
    state
  end

  def render(state) do
    Blinkchain.render()
    state
  end
end
