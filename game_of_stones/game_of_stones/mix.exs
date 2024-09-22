defmodule GameOfStones.MixProject do
  use Mix.Project

  def project do
    [
      app: :game_of_stones,
      version: "0.1.0",
      elixir: "~> 1.17",
      escript: [main_module: GameOfStones.Client],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      env: [default_stones: 30],
      extra_applications: [:logger],
      # callback module
      mod: {GameOfStones.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:colors, "~> 1.1"}]
  end
end
