mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/output/count
mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/output/ratio
list=/scratch/yz77862/CUTnTag_neo4Ls/data/list
while read i;do
echo '#!/bin/bash' >> ${out}
echo "#SBATCH --job-name=${i}_normalization" >> ${out}                 
echo "#SBATCH --partition=batch" >> ${out}   		                            
echo "#SBATCH --ntasks=1" >> ${out}   			                            
echo "#SBATCH --cpus-per-task=4" >> ${out}   		                       
echo "#SBATCH --mem=400gb" >> ${out}   			                               
echo "#SBATCH --time=168:00:00" >> ${out}     		                          
echo "#SBATCH --output=${i}_normalization.out" >> ${out}   			  
echo "#SBATCH --error=${i}_normalization.err" >> ${out}   
echo " " >> ${out}   
echo "cd /scratch/yz77862/CUTnTag_neo4Ls/output/count" >> ${out}   
echo "BAMQ20=" >> ${out}   
echo "BAM=" >> ${out}   
echo " " >> ${out} 
echo "bedtools genomecov -ibam ${BAM} -bg > SRR22950215_q20_coverage.bed" >> ${out}
echo "bedtools genomecov -ibam ${BAMQ20} -bg > SRR22950215_q20_coverage.bed" >> ${out}




done < <(cut -f1 ${list} | grep -v 'skip' | sort -u)
