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
echo "  " >> ${out}
echo "/scratch/yz77862/illumina_neo4Ls/data" >> ${out}  
echo "  " >> ${out}
echo "trim_galore --fastqc --gzip --paired ${GENOME}_R1_001.fastq.gz ${GENOME}_R2_001.fastq.gz -o . -a CTGTCTCTTATACACATCT " >> ${out}  
echo "  " >> ${out}
echo "fastq1=/scratch/yz77862/illumina_neo4Ls/data/${i}_R1_001.fastq.gz.trimmed.fastq.gz" >> ${out} 
echo "fastq2=/scratch/yz77862/illumina_neo4Ls/data/${i}_R2_001.fastq.gz.trimmed.fastq.gz" >> ${out} 
echo "genome=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa" >> ${out}
echo "win_10k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa" >> ${out}

echo "SAM=/scratch/yz77862/illumina_neo4Ls/output/SAM" >> ${out}
echo "BAM=/scratch/yz77862/illumina_neo4Ls/output/BAM" >> ${out}
echo "BAMQ20=/scratch/yz77862/illumina_neo4Ls/output/BAMQ20 " >> ${out}
echo "BED=/scratch/yz77862/illumina_neo4Ls/output/BED" >> ${out}
echo "BEDQ20=/scratch/yz77862/illumina_neo4Ls/output/BEDQ20" >> ${out}
echo "TDF=/scratch/yz77862/illumina_neo4Ls/output/TDF" >> ${out}
echo "  " >> ${out}
echo "bwa mem ${genome} ${fastq1} ${fastq2} -M -t 24  > ${SAM}/${i}_ABS.sam" >> ${out}  
echo "samtools view -b -F 4 -S ${SAM}/${i}_ABS.sam -o ${BAM}/${i}_ABS.bam" >> ${out}  
echo "samtools sort -o ${BAM}/${i}_ABS.sorted.bam ${BAM}/${i}_ABS.bam" >> ${out}    
echo "samtools view -q 20 -o ${BAMQ20}/${i}_ABS.sorted_q20.bam ${BAM}/${i}_ABS.sorted.bam" >> ${out}  
echo "samtools index ${BAM}/${i}_ABS.bam" >> ${out}  
echo "samtools index ${BAMQ20}/${i}_ABS.sorted_q20.bam" >> ${out}  
echo "touch flagstat_result.txt" >> ${out}  
echo "echo '${i}_ABS.sorted.bam' >> flagstat_result.txt" >> ${out}  
echo "samtools flagstat ${BAM}/${i}_ABS.sorted.bam >> flagstat_result.txt" >> ${out}  
echo "echo '${BAMQ20}/${i}_ABS.sorted_q20.bam' >> flagstat_result.txt" >> ${out}  
echo "samtools flagstat ${i}_ABS.sorted_q20.bam >> flagstat_result.txt" >> ${out}  
echo "bedtools bamtobed -cigar -i ${i}_ABS.sorted.bam > _${i}_ABS.sorted.bed" >> ${out}  
echo "bedtools bamtobed -cigar -i ${i}_ABS.sorted_q20.bam > _${i}_ABS.sorted_q20.bed" >> ${out}  
echo "igvtools count -w 10000 ${BAM}/${i}_ABS.sorted.bam ${TDF}/${i}_ABS.sorted_q20.10Kb.tdf ${genome}" >> ${out}  
echo "igvtools count -w 10000 ${BAMQ20}/${i}_ABS.sorted_q20.bam ${TDF}/${i}_ABS.sorted_q20.10Kb.tdf ${genome}" >> ${out} 

echo " " >> ${out}  
