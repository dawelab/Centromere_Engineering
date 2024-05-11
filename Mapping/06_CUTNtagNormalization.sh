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
echo "cd /scratch/yz77862/CUTnTag_neo4Ls/ " >> ${out}   
echo "SAM=/scratch/yz77862/CUTnTag_neo4Ls/output/ABS/SAM" >> ${out}
echo "BAM=/scratch/yz77862/CUTnTag_neo4Ls/output/ABS/BAM" >> ${out}
echo "BAMQ20=/scratch/yz77862/CUTnTag_neo4Ls/output/ABS/BAMQ20 " >> ${out}
echo "TDF=/scratch/yz77862/CUTnTag_neo4Ls/output/ABS/TDF" >> ${out}
echo "genomecov=/scratch/yz77862/CUTnTag_neo4Ls/output/ABS/genomecov" >> ${out}
echo "ml BEDTools" >> ${out}

echo "fastq1=/scratch/yz77862/illumina_neo4Ls/data/${i}_R1_001_val_1.fq.gz" >> ${out} 
echo "fastq2=/scratch/yz77862/illumina_neo4Ls/data/${i}_R2_001_val_2.fq.gz" >> ${out} 
echo "genome=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa" >> ${out}

echo "BAMQ20=/scratch/yz77862/CUTnTag_neo4Ls/output/BAMQ20/${i}.sorted_q20.bam" >> ${out}   
echo "BAM=/scratch/yz77862/CUTnTag_neo4Ls/output/BAM/${i}.sorted.bam" >> ${out}   
echo "bwa mem \${genome} \${fastq1} \${fastq2} -M -t 24  > \${SAM}/${i}_ABS.sam" >> ${out}  
echo "samtools view -b -F 4 -S \${SAM}/${i}_ABS.sam -o \${BAM}/${i}_ABS.bam" >> ${out}  
echo "samtools sort -o \${BAM}/${i}_ABS.sorted.bam \${BAM}/${i}_ABS.bam" >> ${out}    
echo "samtools view -q 20 -o \${BAMQ20}/${i}_ABS.sorted_q20.bam \${BAM}/${i}_ABS.sorted.bam" >> ${out}  
echo "samtools index \${BAM}/${i}_ABS.bam" >> ${out}  
echo "samtools index \${BAMQ20}/${i}_ABS.sorted_q20.bam" >> ${out}  
echo "flagstat=/scratch/yz77862/CUTnTag_neo4Ls/output/flagstat_result.txt" >> ${out}  
echo "touch \${flagstat}" >> ${out}  
echo "echo '\${BAM}/${i}_ABS.sorted.bam' >> \${flagstat}" >> ${out}  
echo "samtools flagstat \${BAM}/${i}_ABS.sorted.bam >> \${flagstat}" >> ${out}  
echo "echo '\${BAMQ20}/${i}_ABS.sorted_q20.bam' >> \${flagstat}" >> ${out}  
echo "samtools flagstat \${BAMQ20}/${i}_ABS.sorted_q20.bam >> \${flagstat}" >> ${out}  
echo "igvtools count -w 100000 \${BAMQ20}/${i}_ABS.sorted_q20.bam \${TDF}/${i}_ABS.sorted_q20.100Kb.tdf \${genome}" >> ${out} 
echo "  " >> ${out}

echo " " >> ${out} 
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
