mkdir -p /scratch/yz77862/illumina_neo4Ls/shell
list=/scratch/yz77862/illumina_neo4Ls/data/list
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
echo "cd /scratch/yz77862/illumina_neo4Ls/${i}_" >> ${out}  

echo "fastq1=/scratch/yz77862/illumina_neo4Ls/data/${i}_R1_001.fastq.gz.trimmed.fastq.gz" >> ${out} 
echo "fastq2=/scratch/yz77862/illumina_neo4Ls/data/${i}_R2_001.fastq.gz.trimmed.fastq.gz" >> ${out} 
echo "genome=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa" >> ${out}

echo "bwa mem ${genome} ${fastq1} ${fastq2} -M -t 24  > ${i}_ABS.sam" >> ${out}  
echo " " >> ${out}  
echo "samtools view -b -F 4 -S ${i}_ABS.sam -o ${i}_ABS.bam" >> ${out}  
echo "samtools sort -o ${i}_ABS.sorted.bam  ${i}_ABS.bam" >> ${out}    
echo "samtools view -q 20 -o ${i}_ABS.sorted_q20.bam _${i}_ABS.sorted.bam" >> ${out}  
echo "samtools index ${i}_ABS.sorted.bam" >> ${out}  
echo "samtools index ${i}_ABS.sorted_q20.bam" >> ${out}  
echo "touch flagstat_result.txt" >> ${out}  
echo "echo '${i}_ABS.sorted.bam' >> flagstat_result.txt" >> ${out}  
echo "samtools flagstat ${i}_ABS.sorted.bam >> flagstat_result.txt" >> ${out}  
echo "echo '${i}_ABS.sorted_q20.bam' >> flagstat_result.txt" >> ${out}  
echo "samtools flagstat ${i}_ABS.sorted_q20.bam >> flagstat_result.txt" >> ${out}  
echo "bedtools bamtobed -cigar -i ${i}_ABS.sorted.bam > _${i}_ABS.sorted.bed" >> ${out}  
echo "bedtools bamtobed -cigar -i ${i}_ABS.sorted_q20.bam > _${i}_ABS.sorted_q20.bed" >> ${out}  
echo "igvtools count -w 100000 ${i}_ABS.sorted.bam ${i}_ABS.sorted_q20.20Kb.tdf ${genome}" >> ${out}  
echo "igvtools count -w 100000 ${i}_ABS.sorted_q20.bam ${i}_ABS.sorted_q20.20Kb.tdf ${genome}" >> ${out}  
echo " " >> ${out}  
echo "W22=/scratch/yz77862/illumina_neo4Ls/W22-6.fastq.gz.trimmed.fastq.gz" >> ${out}  
echo "bwa mem ${genome} \${W22} -M -t 24  > W22-6_ABS.sam" >> ${out}  
echo " " >> ${out}  
echo "samtools view -b -F 4 -S _W22-6_ABS.sam -o W22-6_ABS.bam" >> ${out}   
echo "samtools sort -o W22-6_ABS.sorted.bam  W22-6_ABS.bam" >> ${out}    
echo "samtools view -q 20 -o W22-6_ABS.sorted_q20.bam W22-6_ABS.sorted.bam" >> ${out}  
echo "samtools index W22-6_ABS.sorted.bam" >> ${out}  
echo "samtools index W22-6_ABS.sorted_q20.bam" >> ${out}  
echo "touch flagstat_result.txt" >> ${out}  
echo "echo 'W22-6_ABS.sorted.bam' >> flagstat_result.txt" >> ${out}  
echo "samtools flagstat W22-6_ABS.sorted.bam >> flagstat_result.txt" >> ${out}  
echo "echo 'W22-6_ABS.sorted_q20.bam' >> flagstat_result.txt" >> ${out}  
echo "samtools flagstat W22-6_ABS.sorted_q20.bam >> flagstat_result.txt" >> ${out}  
echo "bedtools bamtobed -cigar -i W22-6_ABS.sorted.bam > W22-6_ABS.sorted.bed" >> ${out}  
echo "bedtools bamtobed -cigar -i W22-6_ABS.sorted_q20.bam > W22-6_ABS.sorted_q20.bed" >> ${out}  
echo "igvtools count -w 100000 W22-6_ABS.sorted.bam W22-6_ABS.sorted_q20.20Kb.tdf ${genome}" >> ${out}  
echo "igvtools count -w 100000 W22-6_ABS.sorted_q20.bam W22-6_ABS.sorted_q20.20Kb.tdf ${genome}" >> ${out}  
done << ()
