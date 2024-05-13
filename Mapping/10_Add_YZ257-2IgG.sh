#!/bin/bash
#SBATCH --job-name=YZ257-2                   
#SBATCH --partition=batch		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4		                       
#SBATCH --mem=400gb			                               
#SBATCH --time=20:00:00  		                          
#SBATCH --output=YZ257-2.out			  
#SBATCH --error=YZ257-2.err

ml BEDTools
mkdir -p ${working_dir_ABS}
mkdir -p ${working_dir_Mo17}
mkdir -p ${working_dir_W22}
cd /scratch/yz77862/working
win_100k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_100k_win.bed
YZ257_2=/scratch/yz77862/CUTnTag_neo4Ls/output/BAM/yz252-7-IgG.sorted.bam
YZ257_2_q20=/scratch/yz77862/CUTnTag_neo4Ls/output/BAMQ20/yz252-7-IgG.sorted_q20.bam


bedtools genomecov -ibam  ${YZ257_2} -bg | awk '{print $0,($3-$2)*$4}' OFS="\t" > yz252-7-IgG.sorted.bg.bed
bedtools genomecov -ibam  ${YZ257_2_q20} -bg | awk '{print $0,($3-$2)*$4}' OFS="\t" > yz252-7-IgG.sorted_q20.bg.bed

bedtools intersect -wa -wb -a ${win_100k} -b yz252-7-IgG.sorted.bg.bed | bedtools groupby -c 8 -o sum > yz252-7-IgG.sorted.bg.bed1
bedtools intersect -wa -wb -a ${win_100k} -b yz252-7-IgG.sorted.bg.bed -v | bedtools groupby -c 8 -o sum > yz252-7-IgG.sorted.bg.bed2

cat yz252-7-IgG.sorted.bg.bed1 yz252-7-IgG.sorted.bg.bed2 | sort -b -k1,1 -k2,2n -k3,3n > yz252-7-IgG.sorted.bg_win_100k.bed
rm yz252-7-IgG.sorted.bg.bed1 yz252-7-IgG.sorted.bg.bed2

bedtools intersect -wa -wb -a ${win_100k} -b yz252-7-IgG.sorted_q20.bg.bed | bedtools groupby -c 8 -o sum > yz252-7-IgG.sorted_q20.bg.bed1
bedtools intersect -wa -wb -a ${win_100k} -b yz252-7-IgG.sorted_q20.bg.bed -v | bedtools groupby -c 8 -o sum > yz252-7-IgG.sorted_q20.bg.bed2

cat yz252-7-IgG.sorted_q20.bg.bed1 yz252-7-IgG.sorted_q20.bg.bed2 | sort -b -k1,1 -k2,2n -k3,3n > yz252-7-IgG.sorted_q20.bg_win_100k.bed
rm yz252-7-IgG.sorted_q20.bg.bed1 yz252-7-IgG.sorted_q20.bg.bed2 

bedtools coverage -a ${win_100k} -b ${YZ257_2} -sorted -f 0.5 > yz252-7-IgG.sorted_win_100k_raw_count.bed
bedtools coverage -a ${win_100k} -b ${YZ257_2_q20} -sorted -f 0.5 > yz252-7-IgG.sorted_win_100k_raw_count_q20.bed
