defmodule Classification.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ClassificationWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Classification.PubSub},
      # Start Finch
      {Finch, name: Classification.Finch},
      # Start the Endpoint (http/https)
      ClassificationWeb.Endpoint,
      # Start a worker by calling: Classification.Worker.start_link(arg)
      # {Classification.Worker, arg}
      {Nx.Serving,
       serving: Classification.ResNet.build_model(),
       name: Classification.Serving,
       batch_timeout: 100}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Classification.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ClassificationWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
