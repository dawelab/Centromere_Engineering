mkdir -p /scratch/yz77862/illumina_neo4Ls/shell
list=/scratch/yz77862/illumina_neo4Ls/data/YZ_list
while read i; do
out=/scratch/yz77862/illumina_neo4Ls/shell/${i}__map.sh
echo '#!/bin/bash' >> ${out}
echo "#SBATCH --job-name=map_${i}" >> ${out}                  
echo "#SBATCH --partition=batch">> ${out}  		                            
echo "#SBATCH --ntasks=1">> ${out}  			                            
echo "#SBATCH --cpus-per-task=4">> ${out}  		                       
echo "#SBATCH --mem=400gb">> ${out}  			                               
echo "#SBATCH --time=35:00:00">> ${out}    		                          
echo "#SBATCH --output=map_${i}.out">> ${out}  			  
echo "#SBATCH --error=map_${i}.err">> ${out}  
echo " " >> ${out}  
echo "ml BWA/0.7.17-GCCcore-11.3.0" >> ${out}  
echo "ml BEDTools/2.29.2-GCC-8.3.0" >> ${out}  
echo "ml SAMtools/1.16.1-GCC-11.3.0" >> ${out}  
echo "ml IGV/2.16.1-Java-11" >> ${out} 
echo "ml Trim_Galore/0.6.7-GCCcore-11.2.0" >> ${out} 
echo " #The data input file folder " >> ${out}
echo "cd /scratch/yz77862/illumina_neo4Ls/data" >> ${out}  
echo " #Trim adaptors " >> ${out}
echo "trim_galore --fastqc --gzip --paired ${GENOME}_R1_001.fastq.gz ${GENOME}_R2_001.fastq.gz -o . -a CTGTCTCTTATACACATCT " >> ${out}  
echo " #The trimmed fastq files " >> ${out}
echo "fastq1=/scratch/yz77862/illumina_neo4Ls/data/${i}_R1_001.fastq.gz.trimmed.fastq.gz" >> ${out} 
echo "fastq2=/scratch/yz77862/illumina_neo4Ls/data/${i}_R2_001.fastq.gz.trimmed.fastq.gz" >> ${out} 
echo "#The genome file  " >> ${out}
echo "genome=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa" >> ${out}
echo "#The windows files  " >> ${out}
echo "win_10k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_10k_win.bed" >> ${out} 
echo "win_25k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_25k_win.bed" >> ${out} 
echo "win_50k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_50k_win.bed" >> ${out} 
echo "win_100k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_100k_win.bed" >> ${out} 
echo " #The output file lists " >> ${out}
echo "SAM=/scratch/yz77862/illumina_neo4Ls/output/SAM" >> ${out}
echo "BAM=/scratch/yz77862/illumina_neo4Ls/output/BAM" >> ${out}
echo "BAMQ20=/scratch/yz77862/illumina_neo4Ls/output/BAMQ20 " >> ${out}
echo "BED=/scratch/yz77862/illumina_neo4Ls/output/BED" >> ${out}
echo "BEDQ20=/scratch/yz77862/illumina_neo4Ls/output/BEDQ20" >> ${out}
echo "TDF=/scratch/yz77862/illumina_neo4Ls/output/TDF" >> ${out}
echo "genomecov=/scratch/yz77862/illumina_neo4Ls/output/genomecov" >> ${out}
echo "  " >> ${out}
echo "bwa mem \${genome} \${fastq1} \${fastq2} -M -t 24  > \${SAM}/${i}_ABS.sam" >> ${out}  
echo "samtools view -b -F 4 -S \${SAM}/${i}_ABS.sam -o \${BAM}/${i}_ABS.bam" >> ${out}  
echo "samtools sort -o \${BAM}/${i}_ABS.sorted.bam \${BAM}/${i}_ABS.bam" >> ${out}    
echo "samtools view -q 20 -o \${BAMQ20}/${i}_ABS.sorted_q20.bam \${BAM}/${i}_ABS.sorted.bam" >> ${out}  
echo "samtools index \${BAM}/${i}_ABS.bam" >> ${out}  
echo "samtools index \${BAMQ20}/${i}_ABS.sorted_q20.bam" >> ${out}  
echo "touch flagstat_result.txt" >> ${out}  
echo "echo '\${BAM}/${i}_ABS.sorted.bam' >> flagstat_result.txt" >> ${out}  
echo "samtools flagstat \${BAM}/${i}_ABS.sorted.bam >> flagstat_result.txt" >> ${out}  
echo "echo '${i}_ABS.sorted_q20.bam' >> flagstat_result.txt" >> ${out}  
echo "samtools flagstat \${BAMQ20}/${i}_ABS.sorted_q20.bam >> flagstat_result.txt" >> ${out}  
echo "bedtools bamtobed -cigar -i \${BAM}/${i}_ABS.sorted.bam > \${BED}/${i}_ABS.sorted.bed" >> ${out}  
echo "bedtools bamtobed -cigar -i ${i}_ABS.sorted_q20.bam > _${i}_ABS.sorted_q20.bed" >> ${out}  
echo "igvtools count -w 10000 \${BAM}/${i}_ABS.sorted.bam \${TDF}/${i}_ABS.sorted_q20.10Kb.tdf ${genome}" >> ${out}  
echo "igvtools count -w 10000 \${BAMQ20}/${i}_ABS.sorted_q20.bam \${TDF}/${i}_ABS.sorted_q20.10Kb.tdf ${genome}" >> ${out} 
echo "  " >> ${out}
echo "bedtools genomecov -ibam \${BAM}/${i}_ABS.sorted.bam -bg > ${genomecov}/${i}_genomecov.bed" >> ${out}
echo "bedtools genomecov -ibam  \${BAMQ20}/${i}_ABS.sorted_q20.bam -bg > ${genomecov}/${i}_q20_genomecov.bed" >> ${out}
echo "bedtools intersect -wa -wb -a \${win_10k} -b \${genomecov}/${i}_genomecov.bed | bedtools groupby -c 7 -o sum > \${genomecov}/${i}_win_10k_genomecov.bed1" >> ${out}
echo "bedtools intersect -wa -wb -a \${win_10k} -b \${genomecov}/${i}_q20_genomecov.bed | bedtools groupby -c 7 -o sum > \${genomecov}/${i}_win_10k_q20_genomecov.bed1" >> ${out}
echo "bedtools intersect -wa -wb -a \${win_25k} -b \${genomecov}/${i}_genomecov.bed | bedtools groupby -c 7 -o sum > \${genomecov}/${i}_win_25k_genomecov.bed1" >> ${out}
echo "bedtools intersect -wa -wb -a \${win_25k} -b \${genomecov}/${i}_q20_genomecov.bed | bedtools groupby -c 7 -o sum > \${genomecov}/${i}_win_q20_25k_genomecov.bed1" >> ${out}
echo "bedtools intersect -wa -wb -a \${win_50k} -b \${genomecov}/${i}_genomecov.bed | bedtools groupby -c 7 -o sum > \${genomecov}/${i}_win_50k_genomecov.bed1" >> ${out}
echo "bedtools intersect -wa -wb -a \${win_50k} -b \${genomecov}/${i}_q20_genomecov.bed | bedtools groupby -c 7 -o sum > \${genomecov}/${i}_win_50k_q20_genomecov.bed1" >> ${out}
echo "bedtools intersect -wa -wb -a \${win_100k} -b \${genomecov}/${i}_genomecov.bed | bedtools groupby -c 7 -o sum > \${genomecov}/${i}_win_100k_genomecov.bed1" >> ${out}
echo "bedtools intersect -wa -wb -a \${win_100k} -b \${genomecov}/${i}_q20_genomecov.bed | bedtools groupby -c 7 -o sum > \${genomecov}/${i}_win_100k_q20_genomecov.bed1" >> ${out}
echo " " >> ${out} 
echo "bedtools intersect -wa -wb -a \${win_10k} -b \${genomecov}/${i}_win_10k_genomecov.bed1 -v | awk '{print \$1,\$2,\$3,0}' OFS="\t"> \${genomecov}/${i}_win_10k_genomecov.bed2" >> ${out} 
echo "bedtools intersect -wa -wb -a \${win_10k} -b \${genomecov}/${i}_win_10k_q20_genomecov.bed1 -v | awk '{print \$1,\$2,\$3,0}' OFS="\t"> \${genomecov}/${i}_win_10k_q20_genomecov.bed2" >> ${out} 
echo "bedtools intersect -wa -wb -a \${win_25k} -b \${genomecov}/${i}_win_25k_genomecov.bed1 -v | awk '{print \$1,\$2,\$3,0}' OFS="\t" > \${genomecov}/${i}_win_25k_genomecov.bed2" >> ${out} 
echo "bedtools intersect -wa -wb -a \${win_25k} -b \${genomecov}/${i}_win_q20_25k_genomecov.bed1 -v | awk '{print \$1,\$2,\$3,0}' OFS="\t" > \${genomecov}/${i}_win_q20_25k_genomecov.bed2" >> ${out} 
echo "bedtools intersect -wa -wb -a \${win_50k} -b \${genomecov}/${i}_win_50k_genomecov.bed1 -v | awk '{print \$1,\$2,\$3,0}' OFS="\t" > \${genomecov}/${i}_win_50k_genomecov.bed2 ">> ${out} 
echo "bedtools intersect -wa -wb -a \${win_50k} -b \${genomecov}/${i}_win_50k_q20_genomecov.bed1 -v | awk '{print \$1,\$2,\$3,0}' OFS="\t" > \${genomecov}/${i}_win_50k_q20_genomecov.bed2" >> ${out} 
echo "bedtools intersect -wa -wb -a \${win_100k} -b \${genomecov}/${i}_win_100k_genomecov.bed1 -v | awk '{print \$1,\$2,\$3,0}' OFS="\t" > \${genomecov}/${i}_win_100k_genomecov.bed2" >> ${out} 
echo "bedtools intersect -wa -wb -a \${win_100k} -b \${genomecov}/${i}_win_100k_q20_genomecov.bed1 -v | awk '{print \$1,\$2,\$3,0}' OFS="\t" > \${genomecov}/${i}_win_100k_q20_genomecov.bed2" >> ${out} 
echo " " >> ${out} 
echo "cat \${genomecov}/${i}_win_10k_genomecov.bed1 \${genomecov}/${i}_win_10k_genomecov.bed2 | sort -b -k1,1 -k2,2n -k3,3n  > \${genomecov}/${i}_win_10k_genomecov.bed" >> ${out} 
echo "cat \${genomecov}/${i}_win_10k_q20_genomecov.bed1 \${genomecov}/${i}_win_10k_q20_genomecov.bed2 | sort -b -k1,1 -k2,2n -k3,3n > \${genomecov}/${i}_win_10k_q20_genomecov.bed" >> ${out} 
echo "cat \${genomecov}/${i}_win_25k_genomecov.bed1 \${genomecov}/${i}_win_25k_genomecov.bed2 | sort -b -k1,1 -k2,2n -k3,3n > \${genomecov}/${i}_win_25k_genomecov.bed " >> ${out} 
echo "cat \${genomecov}/${i}_win_q20_25k_genomecov.bed1 \${genomecov}/${i}_win_q20_25k_genomecov.bed2 | sort -b -k1,1 -k2,2n -k3,3n  > \${genomecov}/${i}_win_q20_25k_genomecov.bed" >> ${out} 
echo "cat \${genomecov}/${i}_win_50k_genomecov.bed1 \${genomecov}/${i}_win_50k_genomecov.bed2 | sort -b -k1,1 -k2,2n -k3,3n > \${genomecov}/${i}_win_50k_genomecov.bed" >> ${out} 
echo "cat \${genomecov}/${i}_win_50k_q20_genomecov.bed1 \${genomecov}/${i}_win_50k_q20_genomecov.bed2 | sort -b -k1,1 -k2,2n -k3,3n  > \${genomecov}/${i}_win_50k_q20_genomecov.bed" >> ${out} 
echo "cat \${genomecov}/${i}_win_100k_genomecov.bed1 \${genomecov}/${i}_win_100k_genomecov.bed2  | sort -b -k1,1 -k2,2n -k3,3n  > \${genomecov}/${i}_win_100k_genomecov.bed " >> ${out} 
echo "cat \${genomecov}/${i}_win_100k_q20_genomecov.bed1 \${genomecov}/${i}_win_100k_q20_genomecov.bed2 | sort -b -k1,1 -k2,2n -k3,3n > \${genomecov}/${i}_win_100k_q20_genomecov.bed" >> ${out} 
done < <(cut -f1 ${list} | grep -v 'skip' | sort -u)

echo " " >> ${out}  
