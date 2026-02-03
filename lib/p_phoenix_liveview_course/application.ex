defmodule PPhoenixLiveviewCourse.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PPhoenixLiveviewCourseWeb.Telemetry,
      PPhoenixLiveviewCourse.Repo,
      {DNSCluster, query: Application.get_env(:p_phoenix_liveview_course, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PPhoenixLiveviewCourse.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PPhoenixLiveviewCourse.Finch},
      # Start a worker by calling: PPhoenixLiveviewCourse.Worker.start_link(arg)
      # {PPhoenixLiveviewCourse.Worker, arg},
      # Start to serve requests, typically the last entry
      PPhoenixLiveviewCourseWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PPhoenixLiveviewCourse.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PPhoenixLiveviewCourseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
