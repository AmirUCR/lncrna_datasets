# Introduction
These scripts download lncRNA datasets from FANTOM5 and GENCODE, and combine them into one non-redundant set.

# Some manual steps
Do not run `00_vars.sh` and `01_common.sh` manually.

# Script order and execution
First, let's open `01_fantom5/src/00_vars.sh` in a text editor and look inside. At the top, you can change your conda environment to one that includes the dependencies listed in `env.yaml`. To install an environment using this yaml, run:

```
conda env create -f env.yaml
```

The URLs for `FANTOM_LNCRNA_BED_URL` and `FANTOM_LNCRNA_GTF_URL` and their corresponding file names can be modified according to the newest version, same for `02_gencode/src/00_vars.sh` URLs. 

To start the pipeline for each database, run the following:

1. `chmod +x *.sh`
2. `./02_download_ref.sh`
3. and so on...

All Python scripts must be sourced with `01_common.sh` first:
> `source 01_common.sh && python 02_combine.py`

# Adding new datasets
This is how I would add a new dataset. Follow the same format as the other two: create a folder `03_new_dataset` with `03_new_dataset/src/00_vars.sh` and `03_new_dataset/src/01_common.sh` (you can just copy the `01_common.sh` from `01_fantom5.sh`). Place your variables in `00_vars.sh` and any other reusable functions you want in `01_common.sh`. Write your own pre-processing code for that dataset. Then, open `combine/src/02_combine.py` and add your dataset name and path to:

```
# Add your dataset to this dictionary
# E.g., { name: BED12 path }
dataset_name_to_path = {
    "fantom5": f"{DATA_DIR}/01_fantom5/results/fantom_hg38_lncrna.bed",
    "gencode": f"{DATA_DIR}/02_gencode/results/gencode_lncrna.bed",
}
```

Next, add the lncRNA labels (1 means lncRNA, 0 means not lncRNA) and any other special modifications that that dataset might need under:

```
# Any special modifications for a specific dataset?

# For FANTOM5, the name before pipe | is the gene name,
# and the name after the pipe "[1]" is the transcript.
# For lncRNA, we are interested in the transcripts.
dataset_name_to_dataframe["fantom5"]["name"] = \
    dataset_name_to_dataframe["fantom5"]["name"].apply(
        lambda x: x.split("|")[1]
    )

# All transcripts in FANTOM5 are lncRNAs (label=1)
dataset_name_to_dataframe["fantom5"]["label"] = 1

# All transcripts in GENCODE are lncRNAs (label=1)
dataset_name_to_dataframe["gencode"]["label"] = 1
```

The script should be good to go now. Run

```
source 01_common.sh && python 02_combine.py
```

and find your combined table under `combine/results/`