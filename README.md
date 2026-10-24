DAT 1 
variant-calling-workflow

Step 1: Create the repo on GitHub
Go to github.com/new, signed in as husseinabuammar24-cloud.
Name: variant-calling-workflow
Description: “Containerised FASTQ-to-variants workflow (Snakemake, Docker) benchmarked against GIAB truth set”
Visibility: Public, since recruiters need to see it.
Tick Add a README file.
Add a .gitignore template: choose Python.
Add a license: MIT.
Click Create repository.
This gives you the README, LICENSE and .gitignore without any extra work.

Step 2: Clone it:
bash
git clone https://github.com/husseinabuammar24-cloud/variant-calling-workflow.git
cd variant-calling-workflow
On Windows, do this inside WSL2 (Ubuntu), not PowerShell.
Step 3: Create the skeleton
In either option, run this inside the repo folder:
bash
mkdir -p data scripts results tests
touch VALIDATION.md config.yaml Snakefile
printf "data/\nresults/\n" >> .gitignore


The concept
The project shows that you can do what a diagnostic genomics lab does every day, and that you can prove the result is correct.
A patient’s DNA is sequenced into millions of short text fragments called reads. A bioinformatician has to turn those reads into a list of variants, the places where this person’s DNA differs from the reference genome. Because a doctor may act on that list, a lab must be able to show how accurate its pipeline is.
You build the pipeline and test it on a person whose true variants are already known. That person is HG002, from the public Genome in a Bottle project, and their known variants are the “truth set”. You run your pipeline on HG002’s sequencing data, then compare your variant list with the truth set:
Precision: of the variants you called, how many are real.
Recall: of the real variants, how many you found.
You report both separately for SNVs (single-letter changes) and indels (small insertions and deletions).
The pipeline has four steps:
fastp cleans the reads.
bwa-mem2 places them on the reference genome.
samtools sorts and indexes the alignments.
bcftools calls the variants.
Snakemake chains these steps into one repeatable workflow, and Docker packages the exact tool versions so it runs the same anywhere. This covers the UZ Brussel posting’s requirements for workflow management, containers, Unix and validation.
What we have done so far
#
Step
Status
1
Created the public GitHub repo with README, MIT licence and .gitignore
Done
2
Opened the repo in VS Code on your Mac and created the folders data, scripts, results, tests and the files Snakefile, config.yaml, VALIDATION.md
Done
3
Built the conda environment varcall and checked all five tools run on your Apple Silicon Mac
Done
4
Pinned the exact versions in environment.yml: fastp 1.4.0, bwa-mem2 2.3, samtools 1.24, bcftools 1.24, htslib 1.24, snakemake 9.27.1
Done
5
Committed and pushed to GitHub, with the Miniforge installer kept out of git
Done
6
Looked at the GIAB site and chose HG002, GRCh38, benchmark v4.2.1
Done
7
Wrote scripts/download_truth.sh, which downloads the truth set and cuts it to chr20:10,000,000-12,000,000
File written; needs a clean run

Where you are right now
The script is written but not run properly, because the text was pasted into the terminal instead of being run as a script. The next action is to open a fresh terminal and run:
bash
conda activate varcall
rm -rf data/truth
bash scripts/download_truth.sh
What comes next
Download the GRCh38 chr20 reference.
Get HG002 sequencing reads for the same 2 Mb slice.
Run each tool by hand once, to see what it produces.
Turn the commands into Snakemake rules.
Add the Dockerfile.
Benchmark the calls against the truth set.
Write VALIDATION.md and the README with your real numbers.





---------
DAY 2
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


------------ 
DAY 3 

Reference genome (today’s work)

Downloaded GRCh38 chr20 from UCSC and decompressed it to data/ref/chr20.fa.
Built the samtools index (.fai) and the bwa-mem2 index (.0123, .amb, .ann, .bwt.2bit.64, .pac).
Verified it: chr20 length is 64,444,167, exactly matching your truth VCF, so both use the same coordinates.
Confirmed conda installed bwa-mem2 2.3, matching your pin, and that samtools is 1.24. The 2.2.1 printout is just the program’s own version string.
Learned to read the .fai columns (name, length, offset, bases per line, bytes per line).
Wrote scripts/download_reference.sh and ran it successfully in 16 s, so the reference can now be rebuilt from scratch with one command.

