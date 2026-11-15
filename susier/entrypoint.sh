#!/usr/bin/env bash
set -euo pipefail

# Print the susieR version at container start
if version=$(Rscript -e 'cat(as.character(packageVersion("susieR")))'); then
  echo "susieR version: ${version}"
else
  echo "susieR version: unknown (could not be determined)" >&2
fi

# Default invocation (docker passes CMD ["Rscript"] when no command is given)
# or an explicitly empty command: start an interactive R session.
# Note: `Rscript` with no args only prints usage (R >= 4.x), so use `R`.
if [ "$#" -eq 0 ] || { [ "$#" -eq 1 ] && [ -z "$1" ]; } || { [ "$#" -eq 1 ] && [ "$1" = "Rscript" ]; } then
  if [ -t 0 ]; then
    exec R
  fi
  echo "No command given and stdin is not a terminal." >&2
  echo "Usage:" >&2
  echo "  docker run --rm -it <image>                  # interactive R session" >&2
  echo "  docker run --rm <image> analysis.R           # run a script" >&2
  echo "  docker run --rm <image> -e 'susie_ss(...)'   # run an expression" >&2
  exit 1
fi

# Run the requested Rscript invocation
# (e.g. `docker run <image> analysis.R` or `docker run <image> -e 'susie_ss(...)'`)
exec Rscript "$@"
