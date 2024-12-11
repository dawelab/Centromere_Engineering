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

cd /scratch/yz77862/assembly
#minimap -d AbsGenomePBHIFI_version_1.mmi AbsGenomePBHIFI_version_1.fa
ABS=/scratch/yz77862/assembly/AbsGenomePBHIFI_version_2.fa
fastq=/scratch/yz77862/assembly/ABS_pacbio_hifi.fastq.gz

minimap2 -ax map-hifi ${ABS} ${fastq} > AbsGenomePBHIFI_hifi_read_mapping.sam          

ml SAMtools/1.18-GCC-12.3.0  
samtools view -b -F 4 -S AbsGenomePBHIFI_hifi_read_mapping.sam -o AbsGenomePBHIFI_hifi_read_mapping.bam
samtools sort -o AbsGenomePBHIFI_hifi_read_ABS_sorted.bam AbsGenomePBHIFI_hifi_read_mapping.bam
