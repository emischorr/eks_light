defmodule EksLight.Light do
  use GenServer

  alias EksLight.Effects

  # Client

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def on(), do: GenServer.cast(__MODULE__, {:on})
  def off(), do: GenServer.cast(__MODULE__, {:off})
  def toggle(), do: GenServer.cast(__MODULE__, {:toggle})

  @doc """
  Sets a static color for every LED on the strip

  ## Examples

    iex> EksLight.Light.color("#9400D3")
    :ok

  """
  def color(color) when is_binary(color) do
    GenServer.cast(__MODULE__, {:color, color})
  end

  def color() do
    GenServer.call(__MODULE__, {:color})
  end

  def state() do
    GenServer.call(__MODULE__, {:get_state})
  end

  # Server (Callbacks)

  @impl true
  def init(_args) do
    {:ok, %{count: 60, mode: :static_color, color: "#FFFFFF", on: true}}
  end

  @impl true
  def handle_cast({:on}, state), do: {:noreply, put_on(state)}

  @impl true
  def handle_cast({:off}, state), do: {:noreply, put_off(state)}

  @impl true
  def handle_cast({:toggle}, state) do
    new_state = case state.on do
      true -> put_off(state)
      false -> put_on(state)
    end
    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:color, color}, state) do
    new_state = %{state|mode: :static_color, color: color}
    |> Effects.set_color(color)
    |> Effects.render()
    {:noreply, new_state}
  end

  @impl true
  def handle_call({:color}, _from, state) do
    {:reply, state.color, state}
  end

  @impl true
  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end


  defp put_on(state) do
    %{state|on: true}
    |> Effects.set_color(state.color)
    |> Effects.render()
  end

  defp put_off(state) do
    %{state|on: false}
    |> Effects.set_color("#000000")
    |> Effects.render()
  end

end
