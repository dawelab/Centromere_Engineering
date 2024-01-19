mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/output/genomecov
mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/output/ratio
list=/scratch/yz77862/CUTnTag_neo4Ls/data/list
while read i;do
out=/scratch/yz77862/CUTnTag_neo4Ls/shell/${i}_normalization.sh
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
echo "cd /scratch/yz77862/CUTnTag_neo4Ls/output/genomecov" >> ${out}   
echo "BAMQ20=/scratch/yz77862/CUTnTag_neo4Ls/output/BAMQ20/${i}.sorted_q20.bam" >> ${out}   
echo "BAM=/scratch/yz77862/CUTnTag_neo4Ls/output/BAM/${i}.sorted.bam" >> ${out}   
echo " " >> ${out} 
echo "ml BEDTools" >> ${out}
echo "bedtools genomecov -ibam \${BAM} -bg > ${i}_genomecov.bed" >> ${out}
echo "bedtools genomecov -ibam \${BAMQ20} -bg > ${i}_q20_genomecov.bed" >> ${out}
echo "win_10k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_10k_win.bed" >> ${out} 
echo "win_25k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_25k_win.bed" >> ${out} 
echo "win_50k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_50k_win.bed" >> ${out} 
echo "win_100k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_100k_win.bed" >> ${out} 
echo "genomecov=/scratch/yz77862/CUTnTag_neo4Ls/output/genomecov" >> ${out} 
echo "cd /scratch/yz77862/CUTnTag_neo4Ls/output/ratio" >> ${out} 
echo "bedtools intersect -wa -wb -a ${win_10k} -b \${genomecov}/${i}_genomecov.bed > ${i}_win_10k_genomecov.bed" >> ${out}
echo "bedtools intersect -wa -wb -a ${win_10k} -b \${genomecov}/${i}_q20_genomecov.bed > ${i}_win_10k_q20_genomecov.bed" >> ${out}
echo "bedtools intersect -wa -wb -a ${win_25k} -b \${genomecov}/${i}_genomecov.bed > ${i}_win_25k_genomecov.bed" >> ${out}
echo "bedtools intersect -wa -wb -a ${win_25k} -b \${genomecov}/${i}_q20_genomecov.bed > ${i}_win_q20_25k_genomecov.bed" >> ${out}
echo "bedtools intersect -wa -wb -a ${win_50k} -b \${genomecov}/${i}_genomecov.bed > ${i}_win_50k_genomecov.bed" >> ${out}
echo "bedtools intersect -wa -wb -a ${win_50k} -b \${genomecov}/${i}_q20_genomecov.bed > ${i}_win_50k_q20__genomecov.bed" >> ${out}
echo "bedtools intersect -wa -wb -a ${win_100k} -b \${genomecov}/${i}_genomecov.bed > ${i}_win_100k_genomecov.bed" >> ${out}
echo "bedtools intersect -wa -wb -a ${win_100k} -b \${genomecov}/${i}_q20_genomecov.bed > ${i}_win_100k_q20__genomecov.bed" >> ${out}
done < <(cut -f1 ${list} | grep -v 'skip' | sort -u)
