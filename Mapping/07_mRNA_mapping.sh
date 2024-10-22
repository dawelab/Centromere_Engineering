#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=star
#SBATCH --time=132:00:00
#SBATCH --mem=200G
#SBATCH --ntasks=7
#SBATCH --ntasks-per-node=1
#SBATCH --mail-user=ys33815@uga.edu
#SBATCH --mail-type=END,FAIL
##e end begin fail

module load STAR/2.7.10b-GCC-11.3.0
cd /scratch/yz77862/mRNA

for GENOME in KD4315-2 KD4315-4 KD4315-5 KD4315-8 yz306-2 yz306-3 yz306-5 yz306-6; do
read1=/scratch/yz77862/mRNA/${GENOME}_R1_001_val_1.fq.gz
read2=/scratch/yz77862/mRNA/${GENOME}_R2_001_val_2.fq.gz

STAR --genomeDir /scratch/yz77862/ABS_Pacbio_index \
--runThreadN 6 \
--readFilesIn ${read1} ${read2} \
--readFilesCommand zcat \
--outSAMtype BAM SortedByCoordinate \
--outSAMunmapped Within \
--outSAMattributes Standard \
--outFileNamePrefix ${GENOME}
done
