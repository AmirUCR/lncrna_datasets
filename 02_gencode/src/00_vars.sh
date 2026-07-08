#!/usr/bin/env bash
export ENV="datasets"

# Directories
export WORKFLOW_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PROJECT_DIR="$(cd "${WORKFLOW_DIR}/.." && pwd)"

export DATA_DIR="${PROJECT_DIR}/data"
export SHARED_DIR="${PROJECT_DIR}/../00_shared"

# REFERENCE
export GENOMIC="${SHARED_DIR}/data/genomic"
export DATASET="hg38"
export REF_URL="https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz"
export GTF_URL="https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_49/gencode.v49.annotation.gtf.gz"
export REF="${GENOMIC}/${DATASET}.fa"
export GTF="${GENOMIC}/gencode.v49.annotation.gtf"

export GENCODE_LNCRNA_GTF_URL="https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_49/gencode.v49.long_noncoding_RNAs.gtf.gz"
export GENCODE_LNCRNA_GTF="${DATA_DIR}/gencode.v49.long_noncoding_RNAs.gtf"

# OUT
export OUT_DIR="${PROJECT_DIR}/results"

export GENCODE_LNCRNA_BED="${OUT_DIR}/gencode_lncrna.bed"
