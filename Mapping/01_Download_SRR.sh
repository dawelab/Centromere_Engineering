#!/bin/bash
#SBATCH --job-name=SRR                
#SBATCH --partition=batch		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4 		                       
#SBATCH --mem=400gb  			                               
#SBATCH --time=168:00:00   		                          
#SBATCH --output=SRR.out 			  
#SBATCH --error=SRR.err

##Download the neo4Ls CUT&Tag data using SRAtools  
ml SRA-Toolkit
cd /scratch/yz77862/CUTnTag_neo4Ls/data/
for SRR in SRR22950215 SRR22950216 SRR22950217 SRR22950218 SRR22950219 SRR22950220 SRR22950221 SRR22950222;do
fasterq-dump --split-files ${SRR} 
done

