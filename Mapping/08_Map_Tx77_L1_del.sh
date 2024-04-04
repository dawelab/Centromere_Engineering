
echo '#!/bin/bash' >> ${out}
#SBATCH --job-name=${i}_normalization                
#SBATCH --partition=batch  		                            
#SBATCH --ntasks=1  			                            
#SBATCH --cpus-per-task=4  		                       
#SBATCH --mem=400gb  			                               
#SBATCH --time=20:00:00    		                          
#SBATCH --output=${i}_normalization.out  			  
#SBATCH --error=${i}_normalization.err  
   
cd /scratch/yz77862/CUTnTag_neo4Ls/output/genomecov  
BAMQ20=/scratch/yz77862/CUTnTag_neo4Ls/output/BAMQ20/${i}.sorted_q20.bam  
BAM=/scratch/yz77862/CUTnTag_neo4Ls/output/BAM/${i}.sorted.bam  
 
index=/scratch/yz77862/MaizeGenome/
