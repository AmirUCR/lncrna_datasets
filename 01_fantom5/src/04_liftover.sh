#!/usr/bin/env bash
set -Eeuo pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Load workflow configuration first.
source "${SCRIPT_DIR}/01_common.sh"
source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate "${ENV}"
log "Running ${0##*/}"

if [ ! -f "hg19ToHg38.over.chain.gz" ]; then
    # Download liftover chain
    wget https://hgdownload.soe.ucsc.edu/goldenPath/hg19/liftOver/hg19ToHg38.over.chain.gz
fi

if [ ! -f "liftOver" ]; then
    wget https://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v479/liftOver
    chmod +x liftOver
fi

# Liftover FANTOM5 BED to hg38
# FANTOM5 BED may not be BED12 -- check first
awk '{print NF; exit}' "${FANTOM_hg19_BED_CLEAN}"

# If BED12
./liftOver \
    "${FANTOM_hg19_BED_CLEAN}" \
    hg19ToHg38.over.chain.gz \
    "${FANTOM_hg38_BED}" \
    "${OUT_DIR}/fantom_hg19_to_hg39_unmapped.bed"

log "Mapped  : $(wc -l < ${FANTOM_hg38_BED})"
log "Unmapped: $(wc -l < ${OUT_DIR}/fantom_hg19_to_hg39_unmapped.bed)"

rm "${FANTOM_hg19_BED_CLEAN}"
