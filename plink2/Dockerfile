# hadolint global ignore=DL3006,DL3008,DL3015
# Dockerfile

# -----------------
# Builder container
# -----------------
FROM ubuntu AS unzip

ENV download=https://s3.amazonaws.com/plink2-assets/beta1/plink2_linux_avx2_20261107.zip
RUN apt-get update; \
    apt-get install -y curl unzip; \
    curl ${download}  --output plink2.zip; \
    unzip plink2.zip

# -----------------
# Primary container
# -----------------
FROM ubuntu
COPY --from=unzip plink2 /usr/bin/plink2


