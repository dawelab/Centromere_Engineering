#!/bin/bash
#SBATCH --job-name=map_KD4277                  
#SBATCH --partition=batch 		                            
#SBATCH --ntasks=1 			                            
#SBATCH --cpus-per-task=4 		                       
#SBATCH --mem=200gb 			                               
#SBATCH --time=24:00:00   		                          
#SBATCH --output=map_KD4277.out 			  
#SBATCH --error=map_KD4277.err 

ml BEDTools/2.29.2-GCC-8.3.0  

win_100k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_100k_win.bed 
SAM=/scratch/yz77862/illumina_neo4Ls/output/ABS/SAM
BAM=/scratch/yz77862/illumina_neo4Ls/output/ABS/BAM
BAMQ20=/scratch/yz77862/illumina_neo4Ls/output/ABS/BAMQ20
TDF=/scratch/yz77862/illumina_neo4Ls/output/ABS/TDF
genomecov=/scratch/yz77862/illumina_neo4Ls/output/ABS/genomecov

bedtools genomecov -ibam  ${BAMQ20}/KD4277_ABS.sorted_q20.bam -bg | awk '{print $0,($3-$2)*$4}' OFS="\t" > ${genomecov}/KD4277_q20_genomecov.bed
bedtools intersect -wa -wb -a ${win_100k} -b ${genomecov}/KD4277_q20_genomecov.bed | bedtools groupby -c 8 -o sum > ${genomecov}/KD4277_win_100k_q20_genomecov.bed1
bedtools intersect -wa -wb -a ${win_100k} -b ${genomecov}/KD4277_q20_genomecov.bed -v | awk '{print $1,$2,$3,0}' OFS="\t" > ${genomecov}/KD4277_win_100k_q20_genomecov.bed2 
cat ${genomecov}/KD4277_win_100k_q20_genomecov.bed1 ${genomecov}/KD4277_win_100k_q20_genomecov.bed2 | sort -b -k1,1 -k2,2n -k3,3n > ${genomecov}/KD4277_win_100k_q20_genomecov.bed 
rm ${genomecov}/KD4277_win_100k_q20_genomecov.bed1 ${genomecov}/KD4277_win_100k_q20_genomecov.bed2 
