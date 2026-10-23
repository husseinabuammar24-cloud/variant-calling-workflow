# variant-calling-workflow
Containerised FASTQ-to-variants workflow (Snakemake, Docker) benchmarked against GIAB truth set


# variant-calling-workflow

Containerised FASTQ-to-variants workflow (Snakemake, Docker), benchmarked against the GIAB HG002 truth set.

## Goal
Call SNVs and indels from short-read sequencing data and measure precision and recall
against a known truth set, reported separately for SNVs and indels.

## Pipeline
fastp (read QC/trimming) → bwa-mem2 (alignment) → samtools (sort/index) → bcftools (variant calling)

## Benchmark
- Sample: HG002 (Genome in a Bottle)
- Reference: GRCh38
- Truth set: GIAB v4.2.1
- Region: chr20:10,000,000-12,000,000 (3,071 truth variants)

## Setup
    conda env create -f environment.yml
    conda activate varcall
    bash scripts/download_truth.sh

## Status
- [x] Environment with pinned tool versions
- [x] Truth set download and region subsetting
- [ ] Reference download and indexing
- [ ] HG002 reads for the benchmark region
- [ ] Snakemake workflow
- [ ] Dockerfile
- [ ] Benchmarking and results (see VALIDATION.md)