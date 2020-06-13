defmodule EksLightWeb.PageLive do
  use EksLightWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, color: EksLight.Light.color())}
  end

  @impl
  def handle_event("on_off", _event, socket) do
    EksLight.Light.toggle()
    {:noreply, socket}
  end

  @impl true
  def handle_event("update", %{"color" => color}, socket) do
    EksLight.Light.color(color);
    {:noreply, assign(socket, color: color)}
  end

end
