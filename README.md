# ScratchRelease

Create a release that includes all binaries and dynamic libraries so that it can be ran in a scratch docker image.

Add ScratchRelease to your dependencies.

```elixir
  defp deps do
    [
      {:scratch_release, "~> 0.1.0", runtime: false}
    ]
  end
```

Configure your release to use it.

```elixir
  defp releases do
    [
      example: [
        include_executables_for: [:unix],
        steps: [:assemble, &ScratchRelease.release/1]
      ]
    ]
  end
end
```

In your Dockerfile create a release, and copy it to a scratch image.

```Dockerfile
FROM elixir:1.14-alpine  as builder
WORKDIR app
RUN mix local.hex --force
COPY mix.* ./
RUN mix deps.get
RUN mix deps.compile
COPY lib lib
RUN mix release --path /release

FROM scratch
COPY --from=builder /release /
CMD ["/minimal/bin/minimal", "start"]
```

The docs can be found at <https://hexdocs.pm/scratch_release>.
