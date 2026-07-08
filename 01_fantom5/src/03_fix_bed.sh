#!/usr/bin/env bash
set -Eeuo pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Load workflow configuration first.
source "${SCRIPT_DIR}/01_common.sh"
source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate "${ENV}"
log "Running ${0##*/}"

mkdir -p "${OUT_DIR}"

# Set the score and itemRgb columns to 0. 
# Otherwise liftOver tool complains...
awk 'BEGIN{OFS="\t"} {$5=0; $9=0; print}' \
    "${FANTOM_LNCRNA_BED}" > "${FANTOM_hg19_BED_CLEAN}"
