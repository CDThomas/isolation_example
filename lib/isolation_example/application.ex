defmodule IsolationExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      IsolationExample.Repo,
      # Start the Telemetry supervisor
      IsolationExampleWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: IsolationExample.PubSub},
      # Start the Endpoint (http/https)
      IsolationExampleWeb.Endpoint
      # Start a worker by calling: IsolationExample.Worker.start_link(arg)
      # {IsolationExample.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: IsolationExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    IsolationExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
