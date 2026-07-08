#!/usr/bin/env bash
set -Eeuo pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Load workflow configuration first.
source "${SCRIPT_DIR}/01_common.sh"
source "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate "${ENV}"
log "Running ${0##*/}"

mkdir -p "${OUT_DIR}"

# UCSC tools to convert GTF to genePred, then genePred to BED
gtfToGenePred "${GENCODE_LNCRNA_GTF}" "${OUT_DIR}/gencode_lncrna.genepred"
genePredToBed "${OUT_DIR}/gencode_lncrna.genepred" "${GENCODE_LNCRNA_BED}"

# Clean up intermediate file
rm "${OUT_DIR}/gencode_lncrna.genepred"

# Filter to canonical chromosomes only (chr1-chr22, chrX, chrY, chrM)
# GENCODE annotates transcripts on unplaced scaffolds (e.g. MU273365.1) and
# alternative contigs that are not part of the primary chromosome assembly.
# These are excluded here since they are absent from the reference FASTA
# and would cause bedtools getfasta to skip them with a WARNING.
log "Dropping rows with non-canonical chromosomes"
log "Before: $(wc -l < ${GENCODE_LNCRNA_BED})"
awk '$1 ~ /^chr([0-9]+|X|Y|M)$/' "${GENCODE_LNCRNA_BED}" > "${OUT_DIR}/gencode_lncrna_canonical.bed"
# Check how many were removed
log "After : $(wc -l < ${OUT_DIR}/gencode_lncrna_canonical.bed)"

# Replace original with canonical
mv "${GENCODE_LNCRNA_BED}" "${GENCODE_LNCRNA_BED}.old"
mv "${OUT_DIR}/gencode_lncrna_canonical.bed" "${GENCODE_LNCRNA_BED}"
rm "${GENCODE_LNCRNA_BED}.old"
