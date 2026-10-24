#!/usr/bin/env bash
# Download GRCh38 chr20 from UCSC and build the samtools and bwa-mem2 indexes.
set -euo pipefail

REF_DIR="data/ref"
mkdir -p "$REF_DIR"

if [ ! -f "$REF_DIR/chr20.fa" ]; then
    curl -L -o "$REF_DIR/chr20.fa.gz" \
        https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr20.fa.gz
    gunzip "$REF_DIR/chr20.fa.gz"
fi

samtools faidx "$REF_DIR/chr20.fa"
bwa-mem2 index "$REF_DIR/chr20.fa"