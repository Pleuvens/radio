defmodule Radio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RadioWeb.Telemetry,
      # Start the Ecto repository
      Radio.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Radio.PubSub},
      # Start Finch
      {Finch, name: Radio.Finch},
      # Start the Endpoint (http/https)
      RadioWeb.Endpoint,
      # Start a worker by calling: Radio.Worker.start_link(arg)
      # {Radio.Worker, arg}
      {Registry, keys: :unique, name: :radio_player_registry},
      # Start the player
      {RadioPlayer, "default"}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Radio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RadioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
