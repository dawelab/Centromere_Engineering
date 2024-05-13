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

bedtools intersect 
for i in *ABS.sorted_q20.bam;do 
bedtools coverage -a ${win_100k} -b ${i} -sorted -f 0.5 > ${working_dir_ABS}/${i}.cov
done

