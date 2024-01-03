#!/bin/bash
#SBATCH --job-name=build_index                     
#SBATCH --partition=batch		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4		                       
#SBATCH --mem=400gb			                               
#SBATCH --time=168:00:00  		                          
#SBATCH --output=trim_adaptor.out			  
#SBATCH --error=trim_adaptor.err

############################################
##Bulid the index ####
############################################

ml BWA/0.7.17-GCCcore-11.3.0
cd /scratch/yz77862/MaizeGenome

#####Change the naming of chr in genome files
awk -v output_file="AbsGenomePBHIFI_version_1_addname.fa" '/^>/ {sub(/$/, "_ABS", $0); print > output_file; next} {print >> output_file}' AbsGenomePBHIFI_version_1.fa
awk -v output_file="Zm-A188-REFERENCE-KSU-1.0_addname.fa" '/^>/ {sub(/$/, "_A188", $0); print > output_file; next} {print >> output_file}' Zm-A188-REFERENCE-KSU-1.0.fa
awk -v output_file="Zm-Mo17-REFERENCE-CAU-2.0_addname.fa" '/^>/ {sub(/$/, "_Mo17", $0); print > output_file; next} {print >> output_file}' Zm-Mo17-REFERENCE-CAU-2.0.fa
awk -v output_file="Zm-B73-REFERENCE-NAM-5.0_addname.fa" '/^>/ {sub(/$/, "_B73", $0); print > output_file; next} {print >> output_file}' Zm-B73-REFERENCE-NAM-5.0.fa
awk -v output_file="Zm-W22-REFERENCE-NRGENE-2.0_addname.fa" '/^>/ {sub(/$/, "_W22", $0); print > output_file; next} {print >> output_file}' Zm-W22-REFERENCE-NRGENE-2.0.fa

###Concat two different genome together
ABS_assembly=/scratch/yz77862/MaizeGenome/AbsGenomePBHIFI_version_1_addname.fa
A188=/scratch/yz77862/MaizeGenome/Zm-A188-REFERENCE-KSU-1.0_addname.fa
B73=/scratch/yz77862/MaizeGenome/Zm-B73-REFERENCE-NAM-5.0_addname.fa
Mo17=/scratch/yz77862/MaizeGenome/Zm-Mo17-REFERENCE-CAU-2.0_addname.fa
W22=/scratch/yz77862/MaizeGenome/Zm-W22-REFERENCE-NRGENE-2.0_addname.fa

cat ${ABS} ${A188} > ABS_A188.fa
cat ${ABS} ${B73} > ABS_B73.fa
cat ${ABS} ${Mo17} > ABS_Mo17.fa
cat ${ABS} ${W22} > ABS_W22.fa

cat ${A188} ${B73} > A188_B73.fa
cat ${A188} ${Mo17} > A188_Mo17.fa
cat ${A188} ${W22} > A188_W22.fa

cat ${B73} ${Mo17} > B73_Mo17.fa
cat ${B73} ${W22} > B73_W22.fa
cat ${Mo17} ${W22} > Mo17_W22.fa

for i in *_addname.fa;do bwa index ${i};done
for i in A188*.fa;do bwa index ${i};done
for i in B73*.fa;do bwa index ${i};done
for i in Mo17*.fa;do bwa index ${i};done



########################################################################################
####Mapping####
########################################################################################
ml BWA/0.7.17-GCCcore-11.3.0
ml BEDTools/2.29.2-GCC-8.3.0
ml SAMtools/1.16.1-GCC-11.3.0
ml IGV/2.16.1-Java-11

cd /scratch/yz77862/illumina_neo4Ls
for i in J721 KD4277 KD4289-6 KD4300-7 KD4303-1 KD4303-2 KD4304-1 L6_R1_001 ;do
fastq1=/scratch/yz77862/illumina_neo4Ls/${i}_R1_001.fastq.gz.trimmed.fastq.gz
fastq2=/scratch/yz77862/illumina_neo4Ls/${i}_R2_001.fastq.gz.trimmed.fastq.gz
bwa mem ${ABS_assembly} ${fastq1} ${fastq2} -M -t 24  > ${i}_ABS.sam
bwa mem ${A188} ${fastq1} ${fastq2} -M -t 24  > ${i}_A188.sam
bwa mem ${B73} ${fastq1} ${fastq2} -M -t 24  > ${i}_B73.sam
bwa mem ${Mo17} ${fastq1} ${fastq2} -M -t 24  > ${i}_Mo17.sam

samtools view -b -F 4 -S ${i}.sam -o ${i}.bam 
samtools sort -o ${i}.sorted.bam ${i}.bam 
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

bedtools bamtobed -cigar -i ${i}.sorted.bam > ${i}.sorted.bed
bedtools bamtobed -cigar -i ${i}.sorted_q20.bam > ${i}.sorted_q20.bed
igvtools count -w 100000 ${i}.sorted.bam ${i}.20Kb.tdf ragtag.scaffold.fasta
igvtools count -w 100000 ${i}.sorted_q20.bam ${i}.q20.20Kb.tdf ${genome}

done

het1=/scratch/yz77862/ABS_PacBio_version1/LexA_CENH3_abs4_S23_R1_001.fastq.gz.trimmed.fastq.gz
het2=/scratch/yz77862/ABS_PacBio_version1/LexA_CENH3_abs4_S23_R2_001.fastq.gz.trimmed.fastq.gz
W22=/scratch/yz77862/ABS_PacBio_version1/W22-6.fastq.gz.trimmed.fastq.gz



done
