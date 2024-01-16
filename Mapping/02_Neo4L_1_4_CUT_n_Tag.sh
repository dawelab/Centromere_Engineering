mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/shell
out=/scratch/yz77862/CUTnTag_neo4Ls/shell/${i}_mapping.sh
echo '#!/bin/bash' >> ${out}
echo "#SBATCH --job-name=${i}_CUTnTag_mapping" >> ${out}                 
echo "#SBATCH --partition=batch" >> ${out}   		                            
echo "#SBATCH --ntasks=1" >> ${out}   			                            
echo "#SBATCH --cpus-per-task=4" >> ${out}   		                       
echo "#SBATCH --mem=400gb" >> ${out}   			                               
echo "#SBATCH --time=168:00:00" >> ${out}     		                          
echo "#SBATCH --output=${i}_CUTnTag_mapping.out" >> ${out}   			  
echo "#SBATCH --error=${i}_CUTnTag_mapping.err" >> ${out}   
echo " " >> ${out}   
echo "ml BWA/0.7.17-GCCcore-11.3.0" >> ${out}   
echo "ml BEDTools/2.29.2-GCC-8.3.0" >> ${out}   
echo "ml SAMtools/1.16.1-GCC-11.3.0" >> ${out} 
echo "ml SRA-Toolkit" >> ${out}   
echo "ml Trim_Galore/0.6.7-GCCcore-11.2.0" >> ${out}   
echo "  " >> ${out}   
echo "############################################" >> ${out}   
echo "##Bulid the index for ABS assembly files####" >> ${out}   
echo "############################################" >> ${out}   
echo "#cd /scratch/yz77862/ABS_PacBio_version1" >> ${out}   
echo "ABS_assembly=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa" >> ${out}   
echo "#bwa index ${ABS_assembly}" >> ${out}   
echo "  " >> ${out}   
echo "########################################################################################" >> ${out}   
echo "####Download data, trim the adaptors and map to ABS genome####" >> ${out}   
echo "########################################################################################" >> ${out}
echo "##Download the neo4Ls CUT&Tag data using SRAtools" >> ${out}   
echo "#cd /scratch/yz77862/CUTnTag_neo4Ls/data/"
echo "#for SRR in SRR22950215 SRR22950216 SRR22950217 SRR22950218 SRR22950219 SRR22950220 SRR22950221 SRR22950222;do"
echo "#fasterq-dump --split-files ${SRR}" >> ${out}   
echo "#done"
echo "cd /scratch/yz77862/CUTnTag_neo4Ls" >> ${out}   
echo "##Trim the adaptors" >> ${out}   
echo "#trim_galore --fastqc --gzip --paired ${i}_1.fastq ${i}_2.fastq -o . -a CTGTCTCTTATACACATCT" >> ${out}   
echo "bwa mem \${ABS_assembly} ${i}_1_val_1.fq.gz ${i}_2_val_2.fq.gz -M -t 24  > ${i}.sam" >> ${out}   
echo "samtools view -b -F 4 -S ${i}.sam -o ${i}.bam " >> ${out}   
echo "samtools sort -o ${i}.sorted.bam ${i}.bam " >> ${out}   
echo "samtools view -q 20 -o ${i}_q20.bam ${i}.sorted.bam" >> ${out}   
echo "samtools index ${i}.sorted.bam" >> ${out}   
echo "samtools index ${i}.sorted_q20.bam" >> ${out}   
echo "touch flagstat_result.txt" >> ${out}   
echo "echo '${i}.sorted.bam' >> flagstat_result.txt" >> ${out}   
echo "samtools flagstat ${i}.sorted.bam >> flagstat_result.txt" >> ${out}   
echo "echo '${i}.sorted_q20.bam' >> flagstat_result.txt  " >> ${out}   
echo "samtools flagstat ${i}.sorted.bam >> flagstat_result.txt" >> ${out}   
echo " ">> ${out}   
echo "bedtools bamtobed -cigar -i ${i}.sorted.bam > ${i}.sorted.bed" >> ${out}   
echo "bedtools bamtobed -cigar -i ${i}_q20.bam > ${i}.sorted_q20.bed" >> ${out}   
done
