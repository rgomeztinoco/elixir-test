defmodule RankTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RankTracker.Repo,
      {DNSCluster, query: Application.get_env(:rank_tracker, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RankTracker.PubSub}
      # Start a worker by calling: RankTracker.Worker.start_link(arg)
      # {RankTracker.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: RankTracker.Supervisor)
  end
end
