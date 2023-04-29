defmodule ScratchRelease.MixProject do
  use Mix.Project

  @source_url "https://github.com/sindrip/scratch_release"

  def project do
    [
      app: :scratch_release,
      version: "0.1.0",
      elixir: "~> 1.14",
      deps: deps(),
      package: package(),
      preferred_cli_env: [docs: :docs],
      docs: [extras: "README.md"],
      name: "ScratchRelease",
      description: "Package a release that can run in a scratch docker image",
      source_url: @source_url
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

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
