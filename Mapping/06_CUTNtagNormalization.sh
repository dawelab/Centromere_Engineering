mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/output/genomecov
mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/output/BAM
mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/output/SAM
mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/output/BAMQ20

list=/scratch/yz77862/CUTnTag_neo4Ls/data/list

while read i;do
out=${i}_normalization.sh
echo '#!/bin/bash' >> ${out}
echo "#SBATCH --job-name=${i}_normalization" >> ${out}                 
echo "#SBATCH --partition=batch" >> ${out}   		                            
echo "#SBATCH --ntasks=1" >> ${out}   			                            
echo "#SBATCH --cpus-per-task=4" >> ${out}   		                       
echo "#SBATCH --mem=400gb" >> ${out}   			                               
echo "#SBATCH --time=20:00:00" >> ${out}     		                          
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
echo "genomecov=/scratch/yz77862/CUTnTag_neo4Ls/output/genomecov" >> ${out} 
echo "cd /scratch/yz77862/CUTnTag_neo4Ls/output/genomecov" >> ${out} 
echo "for j in 10 25 50 100; do" >> ${out}  
echo "win=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_\${j}k_win.bed" >> ${out} 
echo "bedtools genomecov -ibam  \${BAMQ20}/${i}_ABS.sorted_q20.bam -bg | awk '{print \$0,(\$3-\$2)*\$4}' OFS="\t" > \${genomecov}/${i}_q20_genomecov.bed" >> ${out}  
echo "bedtools intersect -wa -wb -a \${win} -b \${genomecov}/${i}_genomecov.bed | bedtools groupby -c 7 -o sum > ${i}_win_\${j}k_genomecov.bed1" >> ${out}
echo "bedtools intersect -wa -wb -a \${win} -b \${genomecov}/${i}_q20_genomecov.bed | bedtools groupby -c 7 -o sum > ${i}_win_\${j}k_q20_genomecov.bed1" >> ${out}
echo "bedtools intersect -wa -wb -a \${win} -b ${i}_win_\${j}k_genomecov.bed1 -v | awk '{print \$1,\$2,\$3,0}' OFS="\t"> ${i}_win_\${j}k_genomecov.bed2" >> ${out} 
echo "bedtools intersect -wa -wb -a \${win} -b ${i}_win_\${j}k_q20_genomecov.bed1 -v | awk '{print \$1,\$2,\$3,0}' OFS="\t"> ${i}_win_\${j}k_q20_genomecov.bed2" >> ${out} 
echo "cat ${i}_win_\${j}k_genomecov.bed1 ${i}_win_10k_genomecov.bed2 | sort -b -k1,1 -k2,2n -k3,3n  > ${i}_win_10k_genomecov.bed" >> ${out} 
echo "done" >> ${out} 
done < <(cut -f1 ${list} | grep -v 'skip' | sort -u)
