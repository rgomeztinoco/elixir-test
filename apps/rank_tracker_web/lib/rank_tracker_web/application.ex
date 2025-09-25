defmodule RankTrackerWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RankTrackerWeb.Telemetry,
      # Start a worker by calling: RankTrackerWeb.Worker.start_link(arg)
      # {RankTrackerWeb.Worker, arg},
      # Start to serve requests, typically the last entry
      RankTrackerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RankTrackerWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RankTrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
