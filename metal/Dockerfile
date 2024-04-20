# hadolint global ignore=DL3003,DL3008,DL3015
# Dockerfile
FROM debian:bookworm AS builder

RUN set -ex;                                                                      \
    apt-get update;                                                               \
    apt-get install -y g++ curl cmake unzip zlib1g-dev zlib1g;                                        \
    mkdir -p /usr/src;                                                            \
    cd /usr/src;                                                               \
    curl -L https://github.com/statgen/METAL/archive/refs/tags/2020-05-05.zip --output 2020-05-05.zip; \
    unzip 2020-05-05.zip

WORKDIR /usr/src/METAL-2020-05-05

RUN cmake -D CMAKE_BUILD_TYPE=Release .; \
    make; make install


FROM debian:bookworm AS runtime

COPY --from=builder /usr/src/METAL-2020-05-05/bin/metal /usr/local/bin

ENV PATH=/usr/local/bin:$PATH

CMD ["/usr/sbin/init"]