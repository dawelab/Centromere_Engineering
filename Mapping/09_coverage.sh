#!/bin/bash
#SBATCH --job-name=coverage                   
#SBATCH --partition=batch		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4		                       
#SBATCH --mem=400gb			                               
#SBATCH --time=20:00:00  		                          
#SBATCH --output=coverage.out			  
#SBATCH --error=coverage.err

ml BEDTools
working_dir=/scratch/yz77862/working
working_dir_ABS=/scratch/yz77862/working/ABS
working_dir_Mo17=/scratch/yz77862/working/Mo17
working_dir_W22=/scratch/yz77862/working/W22
mkdir -p ${working_dir_ABS}
mkdir -p ${working_dir_Mo17}
mkdir -p ${working_dir_W22}
cd /scratch/yz77862/illumina_neo4Ls/output/ABS/BAMQ20
win_100k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_100k_win.bed

for i in *ABS.sorted_q20.bam;do 
bedtools coverage -a ${win_100k} -b ${i} -sorted -f 0.5 > ${working_dir_ABS}/${i}.cov
done

for i in *ABS.sorted_q20.bam;do 
bedtools coverage -a ${win_100k} -b ${i} -sorted -f 0.5  > ${working_dir_Mo17}/${i}.cov
done

for i in *ABS.sorted_q20.bam;do 
bedtools coverage -a ${win_100k} -b ${i} -sorted -f 0.5  > ${working_dir_W22}/${i}.cov
done





