#!/bin/bash
#SBATCH --job-name=corrected_win                    
#SBATCH --partition=batch		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4		                       
#SBATCH --mem=400gb			                               
#SBATCH --time=008:00:00  		                          
#SBATCH --output=corrected_win.out			  
#SBATCH --error=corrected_win.err

win_10k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_10k_win.bed
win_25k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_25k_win.bed 
win_50k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_50k_win.bed
win_100k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_100k_win.bed

cd /scratch/yz77862/illumina_neo4Ls/output/genomecov

ml BEDTools

#Calculate the coverage for each bed files
#for i in *genomecov.bed;do
#awk '{print $0,($3-$2)*$4}' OFS="\t" ${i} > ${i}.bp
#done

#Fill the 0s the windows size that lack any reads
for i in *genomecov.bed.bp;do
bedtools intersect -wa -wb -a ${win_10k} -b ${i} | bedtools groupby -o sum -c 8 > ${i}.sum1
bedtools intersect -wa -a ${win_10k} -b ${i} -v | awk '{print $0,0}' OFS="\t" > ${i}.sum2
cat ${i}.sum1 ${i}.sum2 > ${i}.sum
rm ${i}.sum2 ${i}.sum1
done

for i in *sum;do
sort -b -k1,1 -k2,2n -k3,3n ${i} > ${i}.sort
done
