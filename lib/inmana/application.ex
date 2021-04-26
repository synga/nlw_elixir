defmodule Inmana.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Inmana.Repo,
      # Start the Telemetry supervisor
      InmanaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Inmana.PubSub},
      # Start the Endpoint (http/https)
      InmanaWeb.Endpoint,
      # Start a worker by calling: Inmana.Worker.start_link(arg)
      # {Inmana.Worker, arg}

      # Passo o meu Scheduler para ser executado assim que o app iniciar; É executado pelo Supervisor
      Inmana.Supplies.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options

    # estategia de one_for_one, caso der um erro, der um problema, ele vai ver que o processo filho morreu
    # e vai reabrir esse processo em outra thread; isso sem ferrar com os outros processos; É das opções
    # passadas para o Supervisor
    opts = [strategy: :one_for_one, name: Inmana.Supervisor]
    # Supervisor é um processo especial que supervisiona outros processos, ele chama automaticamente a
    # função start_link presente em todos os childrens passados na lista acima.
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    InmanaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
