defmodule Minimal.MixProject do
  use Mix.Project

  def project do
    [
      app: :minimal,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Minimal.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:scratch_release, "~> 0.1.0", runtime: false}
    ]
  end

  defp releases do
    [
      minimal: [
        include_executables_for: [:unix],
        steps: [:assemble, &ScratchRelease.release/1]
      ]
    ]
  end
end
