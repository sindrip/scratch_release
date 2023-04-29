ARG base_image=elixir:1.14-alpine

FROM $base_image as builder
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
