#!/usr/bin/env bash
set +o history  # Turn bash history recording off
OLD_OPTS=$(set +o)
set -Eeuo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${script_dir}/00_vars.sh"

log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}
eval "$OLD_OPTS"
set -o history  # Turn bash history recording back on
