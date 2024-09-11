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
cd /scratch/yz77862/CUTnTag_neo4Ls/data/
list=/scratch/yz77862/CUTnTag_neo4Ls/data/list
while read GENOME;do
trim_galore --fastqc --gzip --paired ${GENOME}_R1_001.fastq.gz ${GENOME}_R2_001.fastq.gz -o . -a CTGTCTCTTATACACATCT  
done < <(cut -f1 ${list} | grep -v 'skip' | sort -u)

#The illumina adaptor seuquence is AGATCGGAAGAGC.
#How to make the list 
#ls *.fastq.gz | sed 's/_R._001.fastq.gz//g'  > list
