#!/bin/bash
#SBATCH --job-name=${i}_mapping               
#SBATCH --partition=batch 		                            
#SBATCH --ntasks=1 			                            
#SBATCH --cpus-per-task=4 		                       
#SBATCH --mem=400gb 			                               
#SBATCH --time=168:00:00   		                          
#SBATCH --output=${i}_normalization.out 			  
#SBATCH --error=${i}_normalization.err" >> ${out}
 
ml BWA/0.7.17-GCCcore-11.3.0
ml BEDTools/2.29.2-GCC-8.3.0
ml SAMtools/1.16.1-GCC-11.3.0
ml IGV/2.16.1-Java-11

#The main working directory

cd /scratch/yz77862/ABS_PacBio_version1
output_dir=/scratch/yz77862/illumina_neo4Ls/output
#######################################################
#####Set up the value for different mapping genome#####
#######################################################
ABS_genome=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa 
#######################################################
#####       Set up the value for input            #####
#######################################################
fastq=/scratch/yz77862/illumina_neo4Ls/data/${i}_R1_001_val_1.fq.gz
#######################################################
#####       Map to different genomes             #####
#######################################################
bwa mem ${ABS_genome} AbsGenomePBHIFI_read_sim.fastq  -M -t 24  > AbsGenomePBHIFI_read_sim.sam
#######################################################
#####       Convert SAM to BAM and sort           #####
#######################################################
samtools view -b -F 4 -S AbsGenomePBHIFI_read_sim.sam -o AbsGenomePBHIFI_read_sim.bam
samtools sort -o AbsGenomePBHIFI_read_sim_sort.bam AbsGenomePBHIFI_read_sim.bam
#######################################################
#####       Filter reads lower than q20           #####
#######################################################
samtools view -q 20 -o AbsGenomePBHIFI_read_sim_sort_q20.bam AbsGenomePBHIFI_read_sim_sort.bam
#######################################################
#####       Create the index files                #####
#######################################################
samtools index AbsGenomePBHIFI_read_sim_sort.bam
samtools index AbsGenomePBHIFI_read_sim_sort_q20.bam
#######################################################
#####                     IGVtools               #####
#######################################################
igvtools count -w 100000 AbsGenomePBHIFI_read_sim_sort.bam AbsGenomePBHIFI_read_sim_sort_100Kb.tdf ${ABS_genome}
igvtools count -w 100000 AbsGenomePBHIFI_read_sim_sort_q20.bam AbsGenomePBHIFI_read_sim_sort_q20_ABS_sorted_100Kb_q20.tdf ${ABS_genome} 
