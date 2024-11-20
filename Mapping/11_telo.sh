#!/bin/bash
#SBATCH --job-name=build_index                     
#SBATCH --partition=batch		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4		                       
#SBATCH --mem=400gb			                               
#SBATCH --time=008:00:00  		                          
#SBATCH --output=trim_adaptor.out			  
#SBATCH --error=trim_adaptor.err

cd /scratch/yz77862/illumina_neo4Ls/output/ABS/BAM
ml BEDTools
ABS_10k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_10k_win.bed
for i in *bam;do
bedtools intersect -a ${ABS_10k} -b ${i} -c -sorted > ${i}_10k.bed
done
