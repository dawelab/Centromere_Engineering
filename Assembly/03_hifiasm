#!/bin/bash
#SBATCH --job-name=bwa_index                     
#SBATCH --partition=highmem_p		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4		                       
#SBATCH --mem=800gb			                               
#SBATCH --time=168:00:00  		                          
#SBATCH --output=bwa_index.out			  
#SBATCH --error=bwa_index.err

ml Hifiasm/0.19.4-r575-foss-2019b
cd /scratch/yz77862/Pac_bio_HIFI/ftp.genome.arizona.edu/hifiasm
####Assembly the genome disable post joining
hifiasm -t 256 -o Zmays_Abs4-2cells_hifiasm_l0 -l 0 -u --write-ec *.fastq.gz > Zmays_Abs4-2cells_hifiasm_l0.stdout

####Assembly the genome enable post joining
hifiasm -t 256 -o Zmays_Abs4-2cells_hifiasm_l0 -l 0 --write-ec *.fastq.gz > Zmays_Abs4-2cells_hifiasm_l0.stdout
