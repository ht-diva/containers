# Multi-stage Dockerfile for susier environment (SuSiE R package)

# Stage 1: Create conda environment
from condaforge/miniforge3:26.9.4-2 as conda-builder

# Copy the environment file from build context
copy environment.yml /tmp/environment.yml

# Create the environment with all R dependencies
run conda env create -n susier -f /tmp/environment.yml && \
    rm /tmp/environment.yml && \
    conda clean -afy

# Stage 2: Install susieR from the pinned GitHub tag (overwrites any older conda r-susier)
from conda-builder as susier-builder
# Pinned susieR version: install it from this GitHub tag and assert it at build time
arg SUSIER_VERSION=2.0.0

# make + the conda C/C++ toolchain are required to compile susieR from source
# (r-base's Makeconf calls aarch64-conda-linux-gnu-c++, absent from the miniforge3 base)
run conda install -y -n base --quiet make c-compiler cxx-compiler && conda clean -afy

run printf 'download.file("https://codeload.github.com/stephenslab/susieR/tar.gz/refs/tags/%s", "/tmp/susieR.tar.gz", quiet = TRUE)\ninstall.packages("/tmp/susieR.tar.gz", repos = NULL, INSTALL_opts = "--no-multiarch")\n' "$SUSIER_VERSION" > /tmp/install_susieR.r && \
    /opt/conda/envs/susier/bin/Rscript /tmp/install_susieR.r && \
    rm -f /tmp/install_susieR.r /tmp/susieR.tar.gz && \
    conda clean -afy

# Stage 3: Final lean image - only the environment
from condaforge/miniforge3:26.9.4-2
arg SUSIER_VERSION=2.0.0

# Copy only the environment from susier-builder
copy --from=susier-builder /opt/conda/envs/susier /opt/conda/envs/susier

# Set up environment
env PATH=/opt/conda/envs/susier/bin:$PATH

# Verify installation: all packages load AND susieR is exactly the pinned version
run printf 'library(susieR)\nstopifnot(identical(as.character(packageVersion("susieR")), "%s"))\nlibrary(pgenlibr); library(coloc)\ncat("OK: susieR %s + pgenlibr + coloc loaded\\n")\n' "$SUSIER_VERSION" "$SUSIER_VERSION" > /tmp/verify.r && \
    /opt/conda/envs/susier/bin/Rscript /tmp/verify.r && \
    rm -f /tmp/verify.r && \
    conda clean -afy

# Non-root user
run useradd -m -s /bin/bash susier && \
    mkdir -p /app && \
    chown -R susier /opt/conda/envs/susier /app

# Container entrypoint: prints the susieR version, then starts R
copy entrypoint.sh /usr/local/bin/susier-entrypoint.sh
run chmod 0755 /usr/local/bin/susier-entrypoint.sh

user susier

# Set default command
workdir /app
entrypoint ["/usr/local/bin/susier-entrypoint.sh"]
cmd ["Rscript"]
