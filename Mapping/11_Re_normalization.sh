#!/bin/bash
#SBATCH --job-name=corrected_win                    
#SBATCH --partition=batch		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4		                       
#SBATCH --mem=400gb			                               
#SBATCH --time=168:00:00  		                          
#SBATCH --output=corrected_win.out			  
#SBATCH --error=corrected_win.err

win_10k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_10k_win.bed
win_25k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_25k_win.bed 
win_50k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_50k_win.bed
win_100k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_100k_win.bed

cd /scratch/yz77862/illumina_neo4Ls/output/genomecov

ml BEDTools



for i in *.bp;do
bedtools intersect -wa -wb -a ${win_10k} -b ${i}  | bedtools groupby -c 8 -o sum  > win_10k_${i} 
bedtools intersect -wa -wb -a ${win_25k} -b ${i}  | bedtools groupby -c 8 -o sum > win_25k_${i} 
bedtools intersect -wa -wb -a ${win_50k} -b ${i}  | bedtools groupby -c 8 -o sum > win_50k_${i} 
bedtools intersect -wa -wb -a ${win_100k} -b ${i} | bedtools groupby -c 8 -o sum  > win_100k_${i} 
bedtools intersect -wa -wb -a AbsGenomePBHIFI_version_1_1m_win.bed -b ${i} | bedtools groupby -c 8 -o sum  > win_1m_${i} 
bedtools intersect -wa -wb -a AbsGenomePBHIFI_version_1_5m_win.bed -b ${i} | bedtools groupby -c 8 -o sum  > win_5m_${i} 
done
