mkdir -p /scratch/yz77862/illumina_neo4Ls/shell
for j in ABS_A188 ABS_B73 ABS_Mo17 ABS_W22 A188_B73 A188_Mo17 A188_W22 B73_Mo17 B73_W22 Mo17_W22 AbsGenomePBHIFI_version_1_addname Zm-A188-REFERENCE-KSU-1.0_addname Zm-B73-REFERENCE-NAM-5.0_addname Zm-Mo17-REFERENCE-CAU-2.0_addname Zm-W22-REFERENCE-NRGENE-2.0_addname;do 
  for i in J721 KD4277 KD4289-6 KD4300-7 KD4303-1 KD4303-2 KD4304-1 L6 LexA_CENH3_abs4_S23;do
genome=/scratch/yz77862/MaizeGenome/${j}.fa
fastq1=/scratch/yz77862/illumina_neo4Ls/${i}_R1_001.fastq.gz.trimmed.fastq.gz
fastq2=/scratch/yz77862/illumina_neo4Ls/${i}_R2_001.fastq.gz.trimmed.fastq.gz 

out=/scratch/yz77862/illumina_neo4Ls/shell/${i}_${j}_map.sh
echo '#!/bin/bash' >> ${out}
echo "#SBATCH --job-name=map_${i}_${j}" >> ${out}                  
echo "#SBATCH --partition=batch">> ${out}  		                            
echo "#SBATCH --ntasks=1">> ${out}  			                            
echo "#SBATCH --cpus-per-task=4">> ${out}  		                       
echo "#SBATCH --mem=400gb">> ${out}  			                               
echo "#SBATCH --time=168:00:00">> ${out}    		                          
echo "#SBATCH --output=map_${i}_${j}.out">> ${out}  			  
echo "#SBATCH --error=map_${i}_${j}.err">> ${out}  
echo " " >> ${out}  
echo "ml BWA/0.7.17-GCCcore-11.3.0" >> ${out}  
echo "ml BEDTools/2.29.2-GCC-8.3.0" >> ${out}  
echo "ml SAMtools/1.16.1-GCC-11.3.0" >> ${out}  
echo "ml IGV/2.16.1-Java-11" >> ${out}  
echo "mkdir -p /scratch/yz77862/illumina_neo4Ls/${i}_${j}" >> ${out}  
echo "cd /scratch/yz77862/illumina_neo4Ls/${i}_${j}" >> ${out}  
echo "bwa mem ${genome} ${fastq1} ${fastq2} -M -t 24  > ${j}_${i}_ABS.sam" >> ${out}  
echo " " >> ${out}  
echo "samtools view -b -F 4 -S ${j}_${i}_ABS.sam -o ${j}_${i}_ABS.bam" >> ${out}  
echo "samtools sort -o ${j}_${i}_ABS.sorted.bam  ${j}_${i}_ABS.bam" >> ${out}    
echo "samtools view -q 20 -o ${j}_${i}_ABS.sorted_q20.bam ${j}_${i}_ABS.sorted.bam" >> ${out}  
echo "samtools index ${j}_${i}_ABS.sorted.bam" >> ${out}  
echo "samtools index ${j}_${i}_ABS.sorted_q20.bam" >> ${out}  
echo "touch flagstat_result.txt" >> ${out}  
echo "echo '${j}_${i}_ABS.sorted.bam' >> flagstat_result.txt" >> ${out}  
echo "samtools flagstat ${j}_${i}_ABS.sorted.bam >> flagstat_result.txt" >> ${out}  
echo "echo '${j}_${i}_ABS.sorted_q20.bam' >> flagstat_result.txt" >> ${out}  
echo "samtools flagstat ${j}_${i}_ABS.sorted_q20.bam >> flagstat_result.txt" >> ${out}  
echo "bedtools bamtobed -cigar -i ${j}_${i}_ABS.sorted.bam > ${j}_${i}_ABS.sorted.bed" >> ${out}  
echo "bedtools bamtobed -cigar -i ${j}_${i}_ABS.sorted_q20.bam > ${j}_${i}_ABS.sorted_q20.bed" >> ${out}  
echo "igvtools count -w 100000 ${j}_${i}_ABS.sorted.bam ${j}_${i}_ABS.sorted_q20.20Kb.tdf ${genome}" >> ${out}  
echo "igvtools count -w 100000 ${j}_${i}_ABS.sorted_q20.bam ${j}_${i}_ABS.sorted_q20.20Kb.tdf ${genome}" >> ${out}  
echo " " >> ${out}  
echo "W22=/scratch/yz77862/illumina_neo4Ls/W22-6.fastq.gz.trimmed.fastq.gz" >> ${out}  
echo "bwa mem ${genome} \${W22} -M -t 24  > ${j}_W22-6_ABS.sam" >> ${out}  
echo " " >> ${out}  
echo "samtools view -b -F 4 -S ${j}_W22-6_ABS.sam -o ${j}_W22-6_ABS.bam" >> ${out}   
echo "samtools sort -o ${j}_W22-6_ABS.sorted.bam  ${j}_W22-6_ABS.bam" >> ${out}    
echo "samtools view -q 20 -o ${j}_W22-6_ABS.sorted_q20.bam ${j}_W22-6_ABS.sorted.bam" >> ${out}  
echo "samtools index ${j}_W22-6_ABS.sorted.bam" >> ${out}  
echo "samtools index ${j}_W22-6_ABS.sorted_q20.bam" >> ${out}  
echo "touch flagstat_result.txt" >> ${out}  
echo "echo '${j}_W22-6_ABS.sorted.bam' >> flagstat_result.txt" >> ${out}  
echo "samtools flagstat ${j}_W22-6_ABS.sorted.bam >> flagstat_result.txt" >> ${out}  
echo "echo '${j}_W22-6_ABS.sorted_q20.bam' >> flagstat_result.txt" >> ${out}  
echo "samtools flagstat ${j}_W22-6_ABS.sorted_q20.bam >> flagstat_result.txt" >> ${out}  
echo "bedtools bamtobed -cigar -i ${j}_W22-6_ABS.sorted.bam > ${j}_W22-6_ABS.sorted.bed" >> ${out}  
echo "bedtools bamtobed -cigar -i ${j}_W22-6_ABS.sorted_q20.bam > ${j}_W22-6_ABS.sorted_q20.bed" >> ${out}  
echo "igvtools count -w 100000 ${j}_W22-6_ABS.sorted.bam ${j}_W22-6_ABS.sorted_q20.20Kb.tdf ${genome}" >> ${out}  
echo "igvtools count -w 100000 ${j}_W22-6_ABS.sorted_q20.bam ${j}_W22-6_ABS.sorted_q20.20Kb.tdf ${genome}" >> ${out}  
done
  done
