# syntax=docker/dockerfile:1
# Multi-stage Dockerfile for the susier environment (SuSiE R package)
#
#   Stage 1  conda-builder   : create the conda env from environment.yml
#   Stage 2  susier-builder  : compile & install susieR from the pinned GitHub tag
#   Stage 3  (final)         : lean runtime image + non-root user + entrypoint

# Stage 1: Create conda environment
FROM condaforge/miniforge3:26.9.4-2 AS conda-builder
COPY environment.yml /tmp/environment.yml
RUN conda env create -n susier -f /tmp/environment.yml \
    && rm /tmp/environment.yml \
    && conda clean -afy

# Stage 2: Install susieR from the pinned GitHub tag (overwrites any older conda r-susier)
FROM conda-builder AS susier-builder

# Pinned susieR version: install it from this GitHub tag and assert it at build time.
# (ARG must be re-declared after each FROM to be usable in that stage.)
ARG SUSIER_VERSION=2.0.0

# make + the conda C/C++ toolchain are required to compile susieR from source
# (r-base's Makeconf calls aarch64-conda-linux-gnu-c++, absent from the miniforge3 base)
RUN conda install -y -n base --quiet make c-compiler cxx-compiler \
    && conda clean -afy

RUN printf 'download.file("https://codeload.github.com/stephenslab/susieR/tar.gz/refs/tags/%s", "/tmp/susieR.tar.gz", quiet = TRUE)\ninstall.packages("/tmp/susieR.tar.gz", repos = NULL, INSTALL_opts = "--no-multiarch")\n' "$SUSIER_VERSION" > /tmp/install_susieR.r \
    && /opt/conda/envs/susier/bin/Rscript /tmp/install_susieR.r \
    && rm -f /tmp/install_susieR.r /tmp/susieR.tar.gz \
    && conda clean -afy

# Stage 3: Final lean image - only the environment
FROM condaforge/miniforge3:26.9.4-2
ARG SUSIER_VERSION=2.0.0

# Copy only the environment from susier-builder
COPY --from=susier-builder /opt/conda/envs/susier /opt/conda/envs/susier

# Put the susier env on PATH (expanded at build time from the base image PATH)
ENV PATH=/opt/conda/envs/susier/bin:$PATH

# Verify installation: susieR is exactly the pinned version and key deps load
RUN printf 'library(susieR)\nstopifnot(identical(as.character(packageVersion("susieR")), "%s"))\nlibrary(pgenlibr); library(coloc)\ncat("OK: susieR %s + pgenlibr + coloc loaded\\n")\n' "$SUSIER_VERSION" "$SUSIER_VERSION" > /tmp/verify.r \
    && /opt/conda/envs/susier/bin/Rscript /tmp/verify.r \
    && rm -f /tmp/verify.r \
    && conda clean -afy

# Non-root user
RUN useradd -m -s /bin/bash susier \
    && mkdir -p /app \
    && chown -R susier /opt/conda/envs/susier /app

# Container entrypoint: prints the susieR version, then dispatches to R or Rscript
COPY entrypoint.sh /usr/local/bin/susier-entrypoint.sh
RUN chmod 0755 /usr/local/bin/susier-entrypoint.sh

USER susier
WORKDIR /app
ENTRYPOINT ["/usr/local/bin/susier-entrypoint.sh"]
CMD ["Rscript"]
