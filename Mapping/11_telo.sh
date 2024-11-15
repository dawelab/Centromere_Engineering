#!/bin/bash
#SBATCH --job-name=build_index                     
#SBATCH --partition=batch		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4		                       
#SBATCH --mem=400gb			                               
#SBATCH --time=008:00:00  		                          
#SBATCH --output=trim_adaptor.out			  
#SBATCH --error=trim_adaptor.err

cd /scratch/yz77862/illumina_neo4Ls/data/fasta
ml BLAST+

for i in *.fq.gz.fa;do
blastn -query ${i} -db ABS.fasta_blastdb -out ${i}_blast_diABS_result.xls -task blastn -outfmt 6
done
