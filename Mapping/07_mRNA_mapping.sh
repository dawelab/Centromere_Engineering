#!/bin/bash
#SBATCH --job-name=TrimAdaptor              
#SBATCH --partition=batch                                           
#SBATCH --ntasks=1                                                  
#SBATCH --cpus-per-task=4                                      
#SBATCH --mem=200gb                                                    
#SBATCH --time=10:00:00                                           
#SBATCH --output=TrimAdaptor.out                          
#SBATCH --error=TrimAdaptor.err

ml Trim_Galore/0.6.7-GCCcore-11.2.0 
cd /scratch/yz77862/mRNA
list=/scratch/yz77862/mRNA/list
#while read GENOME;do
#trim_galore --fastqc --gzip --paired ${GENOME}_R1_001.fastq.gz ${GENOME}_R2_001.fastq.gz -o . 
#done < <(cut -f1 ${list} | grep -v 'skip' | sort -u )


ml BWA/0.7.17-GCCcore-11.3.0 
ml BEDTools/2.29.2-GCC-8.3.0 
ml SAMtools/1.16.1-GCC-11.3.0 
ml IGV/2.16.1-Java-11

#The main working directory
mkdir -p /scratch/yz77862/mRNA/output
cd /scratch/yz77862/mRNA/output
output_dir=/scratch/yz77862/mRNA/output
#######################################################
#####Set up the value for different mapping genome#####
#######################################################
ABS_genome=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa  
#######################################################
#####       Set up the value for input            #####
#######################################################
while read GENOME;do
#fastq1=/scratch/yz77862/mRNA/${GENOME}_R1_001_val_1.fq.gz
#fastq2=/scratch/yz77862/mRNA/${GENOME}_R2_001_val_2.fq.gz
#######################################################
#####       Map to different genomes             #####
#######################################################
#bwa mem ${ABS_genome} ${fastq1} ${fastq2} -M -t 24  > ${output_dir}/${GENOME}_ABS.sam 
samtools view -b -F 4 -S ${output_dir}/${GENOME}_ABS.sam -o ${output_dir}/${GENOME}_ABS.bam
samtools sort -o ${output_dir}/${GENOME}_ABS_sorted.bam ${output_dir}/${GENOME}_ABS.bam
samtools view -q 20 -o ${output_dir}/${GENOME}_ABS_sorted_q20.bam ${output_dir}/${GENOME}_ABS_sorted.bam

samtools index ${output_dir}/${GENOME}_ABS_sorted_q20.bam
samtools index ${output_dir}/${GENOME}_ABS.bam
done < <(cut -f1 ${list} | grep -v 'skip' | sort -u )
