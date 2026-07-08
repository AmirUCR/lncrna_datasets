#!/usr/bin/env bash
export ENV="datasets"

# Directories
export WORKFLOW_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PROJECT_DIR="$(cd "${WORKFLOW_DIR}/.." && pwd)"

# In
export DATA_DIR="${PROJECT_DIR}/.."

# OUT
export OUT_DIR="${PROJECT_DIR}/results"
export COMBINED_DF="${OUT_DIR}/combined.tsv"
export COMBINED_BED="${OUT_DIR}/combined.bed"
