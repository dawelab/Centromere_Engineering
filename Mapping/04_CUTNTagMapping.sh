mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/output  
mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/output/SAM  
mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/output/BAM  
mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/output/BAMQ20
mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/output/BED
mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/shell

while read i;do
out=/scratch/yz77862/CUTnTag_neo4Ls/shell/${i}_mapping.sh
echo '#!/bin/bash' >> ${out}
echo "#SBATCH --job-name=${i}_CUTnTag_mapping" >> ${out}                 
echo "#SBATCH --partition=batch" >> ${out}   		                            
echo "#SBATCH --ntasks=1" >> ${out}   			                            
echo "#SBATCH --cpus-per-task=4" >> ${out}   		                       
echo "#SBATCH --mem=400gb" >> ${out}   			                               
echo "#SBATCH --time=168:00:00" >> ${out}     		                          
echo "#SBATCH --output=${i}.out" >> ${out}   			  
echo "#SBATCH --error=${i}.err" >> ${out}   
echo " " >> ${out}   
echo "ml BWA/0.7.17-GCCcore-11.3.0" >> ${out}   
echo "ml BEDTools/2.29.2-GCC-8.3.0" >> ${out}   
echo "ml SAMtools/1.16.1-GCC-11.3.0" >> ${out} 
echo "  " >> ${out}   
echo "cd /scratch/yz77862/CUTnTag_neo4Ls/data" >> ${out}   
echo "  " >> ${out}   
echo "SAM=/scratch/yz77862/CUTnTag_neo4Ls/output/SAM" >> ${out}   
echo "BAM=/scratch/yz77862/CUTnTag_neo4Ls/output/BAM" >> ${out}   
echo "BED=/scratch/yz77862/CUTnTag_neo4Ls/output/BED" >> ${out}   
echo "BAMQ20=/scratch/yz77862/CUTnTag_neo4Ls/output/BAMQ20" >> ${out}   
echo "ABS_assembly=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa" >> ${out}
echo "fastq1=/scratch/yz77862/CUTnTag_neo4Ls/data/${i}_val_1.fq.gz" >> ${out}
echo "fastq2=/scratch/yz77862/CUTnTag_neo4Ls/data/${i}_val_2.fq.gz" >> ${out}
echo "  " >> ${out}   
echo "bwa mem \${ABS_assembly} \${fastq1} \${fastq2} -M -t 24 > \${SAM}/${i}.sam" >> ${out}   
echo "samtools view -b -F 4 -S \${SAM}/${i}.sam -o \${BAM}/${i}.bam " >> ${out} 
echo "samtools sort -o \${BAM}/${i}.sorted.bam \${BAM}/${i}.bam " >> ${out}  
echo "cd \${BAM}" >> ${out}  
echo "samtools index \${BAM}/${i}.sorted.bam" >> ${out}   
echo "rm \${BAM}/${i}.bam" >> ${out}   
echo "samtools view -q 20 -o \${BAMQ20}/${i}_q20.bam \${BAM}/${i}.sorted.bam" >> ${out} 
echo "samtools sort -o \${BAMQ20}/${i}.sorted_q20.bam \${BAMQ20}/${i}_q20.bam " >> ${out}
echo "cd \${BAMQ20}" >> ${out}  
echo "samtools index \${BAMQ20}/${i}.sorted_q20.bam" >> ${out}   
echo " ">> ${out}   
echo "bedtools bamtobed -cigar -i \${BAM}/${i}.sorted.bam > \${BED}/${i}.sorted.bed" >> ${out}   
echo "bedtools bamtobed -cigar -i \${BAMQ20}/${i}.sorted_q20.bam > \${BED}/${i}.sorted_q20.bed" >> ${out}   
done < <(cut -f1 ${list} | grep -v 'skip' | sort -u)
