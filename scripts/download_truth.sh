#!/usr/bin/env bash
set -euo pipefail

BASE="https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/NISTv4.2.1/GRCh38"
OUT="data/truth"
REGION="chr20:10000000-12000000"
PREFIX="HG002_GRCh38_1_22_v4.2.1_benchmark"

mkdir -p "$OUT"
for f in "$PREFIX.vcf.gz" "$PREFIX.vcf.gz.tbi" "${PREFIX}_noinconsistent.bed"; do
  [ -f "$OUT/$f" ] || curl -fL -o "$OUT/$f" "$BASE/$f"
done

# Cut the truth set down to one 2 Mb slice of chr20
bcftools view -r "$REGION" -Oz -o "$OUT/truth_chr20_10-12Mb.vcf.gz" "$OUT/$PREFIX.vcf.gz"
tabix -p vcf "$OUT/truth_chr20_10-12Mb.vcf.gz"
awk -v s=10000000 -v e=12000000 '$1=="chr20" && $3>s && $2<e' \
  "$OUT/${PREFIX}_noinconsistent.bed" > "$OUT/confident_chr20_10-12Mb.bed"