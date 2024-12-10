#!/bin/bash
#SBATCH --job-name=${i}_mapping              
#SBATCH --partition=batch		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4		                       
#SBATCH --mem=400gb			                               
#SBATCH --time=168:00:00  		                          
#SBATCH --output=${i}_normalization.out			  
#SBATCH --error=${i}_normalization.err

ml BWA/0.7.17-GCCcore-11.3.0
ml BEDTools/2.29.2-GCC-8.3.0
ml SAMtools/1.16.1-GCC-11.3.0
ml IGV/2.16.1-Java-11
 
#The main working directory
cd /scratch/yz77862/work_final/Yibing_KAPA
i=
W22_genome=/scratch/yz77862/MaizeGenome/Zm-W22-REFERENCE-NRGENE-2.0.fa 
fastq1=/scratch/yz77862/illumina_neo4Ls/data/${i}_R1_001_val_1.fq.gz
fastq2=/scratch/yz77862/illumina_neo4Ls/data/${i}_R2_001_val_2.fq.gz

bwa mem ${W22_genome} ${fastq1} ${fastq2} -M -t 24  > ${i}_W22.sam
#######################################################
#####       Convert SAM to BAM and sort           #####
#######################################################
samtools view -b -F 4 -S ${i}_W22.sam -o ${i}_W22.bam
samtools sort -o ${i}_ABS_sorted.bam ${i}_W22.bam 
#######################################################
#####       Filter reads lower than q20           #####
#######################################################
samtools view -q 20 -o ${i}_W22_sorted_q20.bam ${i}_W22_sorted.bam
#######################################################
#####             100kb-window files               #####
#######################################################
win100k_W22=/scratch/yz77862/MaizeGenome/W22_100k_win.bed
#######################################################
#####             100kb-win genomecov              #####
#########################################c##############
bedtools intersect -a ${win100k_W22} -b ${i}_W22.bed -u > ${i}_W22_100k.bed" >> ${out}
