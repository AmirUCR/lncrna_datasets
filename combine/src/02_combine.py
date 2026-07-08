import os
import pandas as pd

DATA_DIR = os.environ.get("DATA_DIR")

# Add your dataset to this dictionary
# E.g., { name: BED12 path }
dataset_name_to_path = {
    "fantom5": f"{DATA_DIR}/01_fantom5/results/fantom_hg38_lncrna.bed",
    "gencode": f"{DATA_DIR}/02_gencode/results/gencode_lncrna.bed",
}

header = [
    "chrom", "chromStart", "chromEnd",
    "name", "score", "strand", 
    "thickStart", "thickEnd", "itemRgb",
    "blockCount", "blockSizes", "blockStarts",
]

dataset_name_to_dataframe = dict()
for ds_name, ds_path in dataset_name_to_path.items():
    df = pd.read_table(ds_path, names=header)
    df['source'] = ds_name
    dataset_name_to_dataframe[ds_name] = df

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

# ---

# Print some stats. See what we're dealing with
for df_name, df in dataset_name_to_dataframe.items():
    counts = df["label"].value_counts().sort_index()
    total  = len(df)
    print(f"\n── {df_name} ──")
    for label, count in counts.items():
        print(f"  label={label}: {count:,} ({count/total*100:.1f}%.)")
    print(f"  total : {total:,}")

# Combine
combined_df = pd.concat(
    list(dataset_name_to_dataframe.values()), ignore_index=True
)

# Get the base name of a transcript without the .something
# So ENST00000416470.1 returns ENST00000416470
# Leave the name alone if it doesn't start with ENST or ENSG
# so MSTRG.X is left alone.
def base_id(name):
    return name.split(".")[0] \
        if name.startswith(("ENST", "ENSG")) \
        else name

combined_df["name_base"] = combined_df["name"].apply(base_id)

# Deduplicate based on same name_base, same strand, same block structure.
dedup_key = ["name_base", "strand", "blockCount", "blockSizes"]

# Drop duplicate records
combined_dedup = combined_df.drop_duplicates(
    subset=dedup_key, keep="first"
).copy()

# Get which rows were removed.
removed = combined_df[combined_df.duplicated(
    subset=dedup_key, keep="first"
)].copy()

# Save to disk
removed.to_csv("removed.tsv", sep='\t', index=False)

print(f"\n── Removed duplicates ({len(removed):,} total) ──")
print(removed["label"].value_counts().sort_index())

print(f"\n── Removed duplicates by source ──")
print(removed.groupby(["source", "label"]).size().reset_index(name="count"))

counts = combined_dedup["label"].value_counts().sort_index()
total  = len(combined_dedup)
print(f"\n── Combined (deduplicated) ──")
for label, count in counts.items():
    print(f"  label={label}: {count:,} ({count/total*100:.1f}%)")
print(f"  total : {total:,}")
print(f"\n  Removed {len(combined_df) - total:,} duplicates")

combined_dedup = combined_dedup.drop(columns='name_base')

print(f"\n── COMBINED_DEDUP by source ──")
for source, grp in combined_dedup.groupby("source"):
    counts = grp["label"].value_counts().sort_index()
    total  = len(grp)
    print(f"\n  {source}")
    for label, count in counts.items():
        print(f"    label={label}: {count:,} ({count/total*100:.1f}%)")
    print(f"    total : {total:,}")
print(f"\n Total: {len(combined_dedup):,}")

# Remove records with too-short exons
MIN_EXON_SIZE = 2

def has_short_exon(sizes_str):
    return any(s < MIN_EXON_SIZE for s in map(int, sizes_str.split(",")[:-1]))

mask = combined_dedup["blockSizes"].apply(has_short_exon)
print(f"Removing transcripts with exon < {MIN_EXON_SIZE} bases: {mask.sum()}")
combined_dedup = combined_dedup[~mask].copy()
print(f"Total transcripts: {len(combined_dedup)}")

# --- OUTPUT ---
OUT_DIR = os.environ.get("OUT_DIR")
os.makedirs(OUT_DIR, exist_ok=True)

COMBINED_DF = os.environ.get("COMBINED_DF")
COMBINED_BED = os.environ.get("COMBINED_BED")

combined_dedup.to_csv(f"{COMBINED_DF}", sep='\t', index=False)
combined_dedup.iloc[:, :12].to_csv(f"{COMBINED_BED}", sep='\t', header=None, index=False)
