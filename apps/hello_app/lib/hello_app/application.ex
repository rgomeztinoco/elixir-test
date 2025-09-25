defmodule HelloApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HelloApp.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:hello_app, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:hello_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HelloApp.PubSub}
      # Start a worker by calling: HelloApp.Worker.start_link(arg)
      # {HelloApp.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: HelloApp.Supervisor)
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") == nil
  end
end
