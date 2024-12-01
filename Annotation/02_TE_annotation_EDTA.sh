#!/bin/bash
#SBATCH --job-name=EDTA
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --mem=400G
#SBATCH --time=68:00:00
#SBATCH --export=NONE
#SBATCH --output=EDTA.out
#SBATCH --error=EDTA.err

cd /scratch/yz77862/TE_annotation
ml EDTA/2.2.0

genome=/scratch/yz77862/TE_annotation/AbsGenomePBHIFI_version_1.fa
cds=/scratch/yz77862/TE_annotation/Zm-A188-REFERENCE-KSU-1.0_Zm00056aa.1.cds.fa

EDTA.pl \
  --genome ${genome} \
  --species Maize \
  --step anno  \
  --overwrite 1  \
  --cds ${cds} \
  --u 1.3e-8 \
  --threads 18
