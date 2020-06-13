defmodule EksLight.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      EksLightWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: EksLight.PubSub},
      # Start the Endpoint (http/https)
      EksLightWeb.Endpoint,
      # Start a worker by calling: EksLight.Worker.start_link(arg)
      # {EksLight.Worker, arg}
      EksLight.Light
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EksLight.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EksLightWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
