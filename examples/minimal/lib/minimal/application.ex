defmodule Minimal.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    Logger.info("Started Application")

    children = [
      # Starts a worker by calling: Minimal.Worker.start_link(arg)
      # {Minimal.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Minimal.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
