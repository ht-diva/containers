# hadolint global ignore=DL3008,DL3003,DL3015
# Dockerfile

# -----------------
# Builder container
# -----------------
FROM ubuntu:24.10 AS builder

# Set environment variables for configuration
ENV BCFTOOLS_VERSION=1.20

# Update the package lists and install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    unzip \
    build-essential \
    autoconf \
    automake \
    make \
    gcc \
    perl \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libperl-dev \
    libgsl0-dev

# Download and install bcftools
RUN cd /opt && \
    wget -q https://github.com/samtools/bcftools/releases/download/${BCFTOOLS_VERSION}/bcftools-${BCFTOOLS_VERSION}.tar.bz2 && \
    tar -xjf bcftools-${BCFTOOLS_VERSION}.tar.bz2 && \
    cd bcftools-${BCFTOOLS_VERSION} && \
    ./configure --prefix=/opt/bcftools && \
    make && \
    make install


# -----------------
# Primary container
# -----------------
#FROM gcr.io/distroless/base-debian12
FROM ubuntu:24.10

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libcurl4 \
    libcholmod5 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# copy over the generated environment
COPY --from=builder /opt/bcftools /opt/bcftools
COPY plugins /opt/bcftools/libexec/bcftools
ENV BCFTOOLS_PLUGINS="/opt/bcftools/libexec/bcftools"
ENV PATH="/opt/bcftools/bin:${PATH}"
