#!/bin/bash
#SBATCH --job-name=EDTA
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --mem=100G
#SBATCH --time=68:00:00
#SBATCH --export=NONE
#SBATCH --output=EDTA.out
#SBATCH --error=EDTA.err

cd /scratch/yz77862/ABS_PacBio_version1
ml EDTA/2.1.0

genome=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa
cds=/scratch/yz77862/B73v5_genome/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.cds.fa

EDTA.pl \
  --genome ${genome} \
  --species Maize \
  --step anno  \
  --overwrite 1  \
  --cds ${cds} \
  --anno 1 \
  --evaluate 1 \
  --u 1.3e-8 \
  --threads 18
