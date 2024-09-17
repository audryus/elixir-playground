defmodule Campsite.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    start_cowboy()

    children = [
      # Starts a worker by calling: Campsite.Worker.start_link(arg)
      # {Campsite.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Campsite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_cowboy() do
    dispatch_config = build_dispatch_config()
    transport_opts = [port: 4000]
    protocol_opts = %{env: %{dispatch: dispatch_config}}

    case :cowboy.start_clear(:http, transport_opts, protocol_opts) do
      {:ok, _pid} -> IO.puts("Cowboy started")
      _ -> IO.puts("Failed to start cowboy")
    end
  end

  defp build_dispatch_config do
    :cowboy_router.compile([
      {:_,
       [
         {"/", :cowboy_static, {:priv_file, :campsite, "static/index.html"}},
         {"/images/[...]", :cowboy_static, {:priv_dir, :campsite, "static/images"}},
         {:_, Campsite.Web.PageHandler, Campsite.Web.Router}
       ]}
    ])
  end
end
