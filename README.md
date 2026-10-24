# Variant Calling Workflow

A reproducible short-read variant-calling workflow built with Snakemake and
containerized bioinformatics tools. The project is being developed around the
Genome in a Bottle (GIAB) HG002 sample so calls can be compared with a trusted
benchmark set.

> **Development status:** setup and reference data download scripts are in
> place. The end-to-end workflow, read data, container, and benchmark results
> are still in progress.

## Project overview

The planned workflow processes paired-end FASTQ reads through quality control,
alignment, and variant calling:

```text
FASTQ reads → fastp → bwa-mem2 → samtools → bcftools → VCF variants
```

Calls will be evaluated against the GIAB HG002 truth set, with precision and
recall reported separately for single-nucleotide variants (SNVs) and small
insertions/deletions (indels).

| Benchmark input | Selection |
| --- | --- |
| Sample | HG002 / NA24385 |
| Reference | GRCh38, chromosome 20 |
| Truth set | GIAB v4.2.1 |
| Target interval | chr20:10,000,000–12,000,000 |

## Current progress

- [x] Conda environment with pinned tool versions
- [x] Script to download and index the chr20 reference
- [x] Script to download and subset the GIAB truth set
- [ ] Obtain HG002 reads for the target interval
- [ ] Implement and run the Snakemake workflow
- [ ] Add a container build
- [ ] Benchmark calls and document results in [`VALIDATION.md`](VALIDATION.md)

## Getting started

Create the environment and activate it:

```bash
conda env create -f environment.yml
conda activate varcall
```

Download and prepare the reference and truth data:

```bash
bash scripts/download_reference.sh
bash scripts/download_truth.sh
```

The scripts write generated files under `data/`, which is ignored by Git.
Reference indexing requires `samtools` and `bwa-mem2`; truth-set processing
requires `bcftools` and `tabix` (provided by the pinned environment).

To create the environment with updated dependency pins:

```bash
conda env update -f environment.yml --prune
```

## Tools

The environment pins the following versions:

| Tool | Version | Role |
| --- | --- | --- |
| Snakemake | 9.27.1 | Workflow management |
| fastp | 1.4.0 | Read quality control and trimming |
| bwa-mem2 | 2.3 | Read alignment |
| samtools | 1.24 | Alignment processing |
| bcftools | 1.24 | Variant calling and VCF processing |
| htslib | 1.24 | Genomic data utilities |

## Repository layout

```text
.
├── scripts/
│   ├── download_reference.sh
│   └── download_truth.sh
├── config.yaml
├── environment.yml
├── Snakefile
└── VALIDATION.md
```

## Validation

Benchmark metrics and the completed run procedure will be recorded in
[`VALIDATION.md`](VALIDATION.md) after the calling workflow is implemented.
No pipeline accuracy results are available yet.
