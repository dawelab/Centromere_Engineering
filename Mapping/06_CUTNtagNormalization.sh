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
echo "ml BEDTools" >> ${out}
echo "bedtools genomecov -ibam \${BAM}/ -bg > \${BAM}/${i}_coverage.bed" >> ${out}
echo "bedtools genomecov -ibam \${BAMQ20}/ -bg > \${BAM}/${i}_q20_coverage.bed" >> ${out}
echo "win_10k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_10k_win.bed" >> ${out} 
echo "win_25k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_25k_win.bed" >> ${out} 
echo "win_50k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_50k_win.bed" >> ${out} 
echo "win_100k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_100k_win.bed" >> ${out} 
echo " " >> ${out}
echo " " >> ${out}
echo " " >> ${out}
echo " " >> ${out}
echo " " >> ${out}
done < <(cut -f1 ${list} | grep -v 'skip' | sort -u)
