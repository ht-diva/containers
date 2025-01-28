# hadolint global ignore=DL3008,DL3003,DL3015
# Dockerfile
 
# -----------------
# Builder container
# -----------------
FROM ubuntu:24.10 AS builder
 
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
    pip
 
# Download and install bcftools
RUN apt-get update && apt-get install -y python3-venv && \
    python3 -m venv /opt/venv
 
# Activate the virtual environment and install Crossmap
RUN . /opt/venv/bin/activate && \
    pip install Crossmap==0.7.3
 
# Ensure the virtual environment is added to PATH for later use
ENV PATH="/opt/venv/bin:$PATH"
