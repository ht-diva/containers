# hadolint global ignore=DL3008,DL3003,DL3015
# Dockerfile

FROM ubuntu:24.10

# Update the package lists and install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    gcc \
    zlib1g-dev \
    pip \
    python3-venv

# Create, activate the virtual environment and install Crossmap
RUN python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install Crossmap==0.7.3

# Ensure the virtual environment is added to PATH for later use
ENV PATH="/opt/venv/bin:$PATH"
