ARG base_image=elixir:1.14-alpine

FROM $base_image as builder
WORKDIR scratch_release
COPY . .
WORKDIR examples/minimal
#COPY mix.* .
#COPY lib lib
RUN mix local.hex --force
RUN mix release --path /release

FROM scratch
COPY --from=builder /release /
CMD ["/minimal/bin/minimal", "start"]
