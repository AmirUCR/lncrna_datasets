#!/usr/bin/env bash
set -Eeuo pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Load workflow configuration first.
source "${SCRIPT_DIR}/01_common.sh"
source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate "${ENV}"
log "Running ${0##*/}"

# Create dirs if not present
mkdir -p "${GENOMIC}"
mkdir -p "${DATA_DIR}"

# Get reference genome
# if [ ! -f "${REF}" ]; then
#     log "${REF} not found. Downloading..." 
#     wget -P "${GENOMIC}" "${REF_URL}"
#     gunzip "${REF}.gz"
# else
#     log "${REF} already exists. Skipping." 
# fi

# Download the reference GTF
# if [ ! -f "${GTF}" ]; then
#     log "${GTF} not found. Downloading..." 
#     wget -P "${GENOMIC}" "${GTF_URL}"
#     gunzip "${GTF}.gz"
# else
#     log "${GTF} already exists. Skipping." 
# fi

# Download the FANTOM lncRNA GTF
if [ ! -f "${FANTOM_LNCRNA_GTF}" ]; then
    log "${FANTOM_LNCRNA_GTF} not found. Downloading..." 
    wget -P "${DATA_DIR}" "${FANTOM_LNCRNA_GTF_URL}"
    gunzip "${FANTOM_LNCRNA_GTF}.gz"
else
    log "${FANTOM_LNCRNA_GTF} already exists. Skipping." 
fi

# Download the FANTOM lncRNA BED file
if [ ! -f "${FANTOM_LNCRNA_BED}" ]; then
    log "${FANTOM_LNCRNA_BED} not found. Downloading..." 
    wget -P "${DATA_DIR}" "${FANTOM_LNCRNA_BED_URL}"
    gunzip "${FANTOM_LNCRNA_BED}.gz"
else
    log "${FANTOM_LNCRNA_BED} already exists. Skipping." 
fi
