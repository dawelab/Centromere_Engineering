mkdir -p /scratch/yz77862/illumina_neo4Ls/shell_telo
mkdir -p /scratch/yz77862/illumina_neo4Ls/output/telo/SAM
mkdir -p /scratch/yz77862/illumina_neo4Ls/output/telo/BAM
mkdir -p /scratch/yz77862/illumina_neo4Ls/output/telo/BAMQ20
mkdir -p /scratch/yz77862/illumina_neo4Ls/output/telo/TDF
mkdir -p /scratch/yz77862/illumina_neo4Ls/output/telo/genomecov
list=/scratch/yz77862/illumina_neo4Ls/data/trimmed/list
while read i; do
out=/scratch/yz77862/illumina_neo4Ls/shell_telo/${i}_mapping.sh
echo '#!/bin/bash' >> ${out}
echo "#SBATCH --job-name=map_${i}" >> ${out}                  
echo "#SBATCH --partition=batch">> ${out}  		                            
echo "#SBATCH --ntasks=1">> ${out}  			                            
echo "#SBATCH --cpus-per-task=4">> ${out}  		                       
echo "#SBATCH --mem=200gb">> ${out}  			                               
echo "#SBATCH --time=48:00:00">> ${out}    		                          
echo "#SBATCH --output=map_${i}.out">> ${out}  			  
echo "#SBATCH --error=map_${i}.err">> ${out}  
echo " " >> ${out}  
echo "ml BWA/0.7.17-GCCcore-11.3.0" >> ${out}  
echo "ml BEDTools/2.29.2-GCC-8.3.0" >> ${out}  
echo "ml SAMtools/1.16.1-GCC-11.3.0" >> ${out}  
echo "ml IGV/2.16.1-Java-11" >> ${out} 
echo " #The trimmed fastq files " >> ${out}
echo "fastq1=/scratch/yz77862/illumina_neo4Ls/data/trimmed/${i}_R1_001_val_1.fq.gz" >> ${out} 
echo "fastq2=/scratch/yz77862/illumina_neo4Ls/data/trimmed/${i}_R2_001_val_2.fq.gz" >> ${out} 
echo "#The genome file  " >> ${out}
echo "genome=/scratch/yz77862/TeloSearch/chr4_telo.fa" >> ${out}
echo "SAM=/scratch/yz77862/illumina_neo4Ls/output/telo/SAM" >> ${out}
echo "BAM=/scratch/yz77862/illumina_neo4Ls/output/telo/BAM" >> ${out}
echo "BAMQ20=/scratch/yz77862/illumina_neo4Ls/output/telo/BAMQ20 " >> ${out}
echo "genomecov=/scratch/yz77862/illumina_neo4Ls/output/telo/genomecov" >> ${out}
echo "bwa mem \${genome} \${fastq1} \${fastq2} -M -t 24  > \${SAM}/${i}_telo.sam" >> ${out}  
echo "samtools view -b -F 4 -S \${SAM}/${i}_telo.sam -o \${BAM}/${i}_telo.bam" >> ${out}  
echo "samtools sort -o \${BAM}/${i}_telo.sorted.bam \${BAM}/${i}_telo.bam" >> ${out}    
echo "samtools view -q 20 -o \${BAMQ20}/${i}_telo.sorted_q20.bam \${BAM}/${i}_telo.sorted.bam" >> ${out}  
echo "samtools index \${BAM}/${i}_telo.bam" >> ${out}  
echo "samtools index \${BAMQ20}/${i}_telo.sorted_q20.bam" >> ${out}  
echo "flagstat=/scratch/yz77862/illumina_neo4Ls/output/telo/flagstat_result.txt" >> ${out}  
echo "touch \${flagstat}" >> ${out}  
echo "echo '\${BAM}/${i}_telo.sorted.bam' >> \${flagstat}" >> ${out}  
echo "samtools flagstat \${BAM}/${i}_telo.sorted.bam >> \${flagstat}" >> ${out}  
done < <(cut -f1 ${list} | grep -v 'skip' | sort -u)

