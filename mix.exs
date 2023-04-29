defmodule ScratchRelease.MixProject do
  use Mix.Project

  def project do
    [
      app: :scratch_release,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [docs: :docs],
      name: "ScratchRelease"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :docs, runtime: false}
    ]
  end
end
