defmodule DndTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DndTrackerWeb.Telemetry,
      DndTracker.Repo,
      {DNSCluster, query: Application.get_env(:dnd_tracker, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DndTracker.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: DndTracker.Finch},
      # Start a worker by calling: DndTracker.Worker.start_link(arg)
      # {DndTracker.Worker, arg},
      # Start to serve requests, typically the last entry
      DndTrackerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DndTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DndTrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
