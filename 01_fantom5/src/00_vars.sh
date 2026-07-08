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

export FANTOM_LNCRNA_BED_URL="https://fantom.gsc.riken.jp/5/suppl/Hon_et_al_2016/data/assembly/lv3_robust/FANTOM_CAT.lv3_robust.only_lncRNA.bed.gz"
export FANTOM_LNCRNA_GTF_URL="https://fantom.gsc.riken.jp/5/suppl/Hon_et_al_2016/data/assembly/lv3_robust/FANTOM_CAT.lv3_robust.only_lncRNA.gtf.gz"
export FANTOM_LNCRNA_BED="${DATA_DIR}/FANTOM_CAT.lv3_robust.only_lncRNA.bed"
export FANTOM_LNCRNA_GTF="${DATA_DIR}/FANTOM_CAT.lv3_robust.only_lncRNA.gtf"

# OUT
export OUT_DIR="${PROJECT_DIR}/results"

export FANTOM_hg19_BED_CLEAN="${OUT_DIR}/fantom_hg19_lncrna.bed"
export FANTOM_hg38_BED="${OUT_DIR}/fantom_hg38_lncrna.bed"
