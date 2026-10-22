# Docker builder for 404 NOT FOUND OS.
# Produces the bootable ISO locally on any machine that has Docker.
# Build + run via ./docker-build.sh (needs --privileged, handled there).
FROM debian:bookworm

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      live-build ca-certificates debootstrap xorriso squashfs-tools \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY auto    /build/auto
COPY config  /build/config

# /out is a volume the host mounts to collect the finished ISO.
VOLUME ["/out"]

CMD ["bash","-lc","lb config && lb build && cp -v ./*.iso /out/ && sha256sum /out/*.iso > /out/SHA256SUMS && echo 'DONE -> see ./out'"]
