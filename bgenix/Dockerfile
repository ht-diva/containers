# Dockerfile

# -----------------
# Builder container
# -----------------
FROM condaforge/mambaforge:4.14.0-0 as builder

COPY environment.yml /docker/environment.yml

RUN . /opt/conda/etc/profile.d/conda.sh && \
    mamba create --name lock && \
    conda activate lock && \
    mamba env list && \
    mamba install --yes pip conda-lock>=1.2.2 setuptools wheel && \
    conda lock \
        --file /docker/environment.yml \
        --kind lock \
        --lockfile /docker/conda-lock.yml

RUN . /opt/conda/etc/profile.d/conda.sh && \
    conda activate lock && \
    conda-lock install \
        --mamba \
        --copy \
        --prefix /opt/env \
        /docker/conda-lock.yml && conda clean -afy

# -----------------
# Primary container
# -----------------
FROM gcr.io/distroless/base-debian11
# copy over the generated environment
COPY --from=builder /opt/env /opt/env
ENV PATH="/opt/env/bin:${PATH}"