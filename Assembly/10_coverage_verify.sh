#!/bin/bash
#SBATCH --job-name=minimap
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --mem=400G
#SBATCH --time=168:00:00
#SBATCH --export=NONE
#SBATCH --output=minimap.out
#SBATCH --error=minimap.err
 
ml minimap2/2.28-GCCcore-12.3.0

cd /scratch/yz77862/ABS_PacBio_version1
#minimap -d AbsGenomePBHIFI_version_1.mmi AbsGenomePBHIFI_version_1.fa
ABS=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa
fastq=/scratch/yz77862/work/ABS_pachifi.read.fastq

minimap2 -ax map-hifi ${ABS} ${fastq} > AbsGenomePBHIFI_hifi_read_mapping.sam          

ml SAMtools/1.18-GCC-12.3.0
samtools view -b AbsGenomePBHIFI_hifi_read_mapping.bam  AbsGenomePBHIFI_hifi_read_mapping.sam 
