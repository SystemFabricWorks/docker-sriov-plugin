FROM golang:1.22.2 as build
WORKDIR /go/src/docker-sriov-plugin

COPY . .
RUN export CGO_LDFLAGS_ALLOW='-Wl,--unresolved-symbols=ignore-in-object-files' && \
    go install -ldflags="-s -w" -v docker-sriov-plugin

FROM debian:bookworm-slim
ARG PLUGIN_ARGS=
COPY --from=build /go/bin/docker-sriov-plugin /bin/docker-sriov-plugin
COPY ibdev2netdev /tmp/tools/
RUN echo "$PLUGIN_ARGS" > /tmp/plugin_args
COPY run_docker_sriov_plugin /bin
CMD ["/bin/run_docker_sriov_plugin"]
