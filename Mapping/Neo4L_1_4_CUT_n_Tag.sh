#!/bin/bash
#SBATCH --job-name=CUTnTag_mapping                      
#SBATCH --partition=batch		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4		                       
#SBATCH --mem=400gb			                               
#SBATCH --time=168:00:00  		                          
#SBATCH --output=trim_adaptor.out			  
#SBATCH --error=trim_adaptor.err

ml BWA/0.7.17-GCCcore-11.3.0
ml BEDTools/2.29.2-GCC-8.3.0
ml SAMtools/1.16.1-GCC-11.3.0
ml IGV/2.16.1-Java-11

############################################
##Bulid the index for ABS assembly files####
############################################
cd /scratch/yz77862/ABS_PacBio_version1
ABS_assembly=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa
bwa index ${ABS_assembly}

########################################################################################
####Download data, trim the adaptors and map to ABS genome####
########################################################################################
cd /scratch/yz77862/illumina_neo4Ls
ml SRA-Toolkit
ml Trim_Galore/0.6.7-GCCcore-11.2.0
for i in SRR22950215 SRR22950216 SRR22950217 SRR22950218 SRR22950219 SRR22950220 SRR22950221 SRR22950222;do
##Download the neo4Ls CUT&Tag data using SRAtools
fasterq-dump --split-files ${i}
##Trim the adaptors
trim_galore --fastqc --gzip --paired ${i}_1.fastq ${i}_2.fastq -o . -a CTGTCTCTTATACACATCT
bwa mem ${ABS_assembly} ${i}_1_val_1.fq.gz ${i}_2_val_2.fq.gz -M -t 24  > ${Input}.sam
samtools view -b -F 4 -S ${i}.sam -o ${i}.bam 
samtools sort -o ${it}.sorted.bam ${i}.bam 
samtools view -q 20 -o ${i}_q20.bam ${i}.sorted.bam
samtools index ${i}.sorted.bam
samtools index ${i}.sorted_q20.bam
touch flagstat_result.txt
echo '${Input}.sorted.bam' >> flagstat_result.txt
samtools flagstat ${i}.sorted.bam >> flagstat_result.txt
echo '${Input}.sorted_q20.bam' >> flagstat_result.txt
samtools flagstat ${i}.sorted.bam >> flagstat_result.txt

bedtools bamtobed -cigar -i ${i}.sorted.bam > ${i}.sorted.bed
bedtools bamtobed -cigar -i ${i}.sorted_q20.bam > ${i}.sorted_q20.bed
igvtools count -w 100000 ${i}.sorted.bam ${i}.20Kb.tdf ragtag.scaffold.fasta
igvtools count -w 100000 ${i}.sorted_q20.bam ${i}.q20.20Kb.tdf ragtag.scaffold.fasta
done
