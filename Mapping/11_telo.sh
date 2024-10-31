#!/bin/bash
#SBATCH --job-name=build_index                     
#SBATCH --partition=batch		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4		                       
#SBATCH --mem=400gb			                               
#SBATCH --time=168:00:00  		                          
#SBATCH --output=trim_adaptor.out			  
#SBATCH --error=trim_adaptor.err

cd /scratch/yz77862/work_illu

ml BWA/0.7.17-GCCcore-11.3.0  
ml BEDTools/2.29.2-GCC-8.3.0
ml SAMtools/1.16.1-GCC-11.3.0
ml IGV/2.16.1-Java-11

ABS_genome=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa  
#17-4-2-KAPA 4-3-KAPA 7-TRI-3-KAPA YZ306-1-KAPA YZ306-2-CENH3-1 YZ306-2-CENH3-2 YZ306-2-IgG-1 YZ306-2-IgG-2
i=YZ306-2-IgG-2
fastq1=/scratch/yz77862/work_illu/30-1097707915_chr11-cuttag-KAPA/${i}_R1_001_val_1.fq.gz
fastq2=/scratch/yz77862/work_illu/30-1097707915_chr11-cuttag-KAPA/${i}_R2_001_val_2.fq.gz
bwa mem ${ABS_genome} ${fastq1} ${fastq2} -M -t 24  > ${i}_ABS.sam 
samtools view -b -F 4 -S ${i}_ABS.sam -o ${i}_ABS.bam 
samtools sort -o ${i}_ABS_sorted.bam ${i}_ABS.bam
samtools view -q 20 -o ${i}_ABS_sorted_q20.bam ${i}_ABS_sorted.bam 
samtools index ${i}_ABS_sorted.bam 
samtools index ${i}_ABS_sorted_q20.bam 
igvtools count -w 100000 ${i}_ABS_sorted.bam ${i}_ABS_sorted_100Kb.tdf ${ABS_genome}
bedtools genomecov -ibam ${i}_ABS_sorted.bam -bg > ${i}_ABS_sorted.bed
bedtools genomecov -ibam ${i}_ABS_sorted_q20.bam -bg > ${i}_ABS_sorted_q20.bed
awk '{print $1,$2,$3,$4,($3-$2)*$4}' OFS="\t" ${i}_ABS_sorted.bed > ${i}_ABS.bed
awk '{print $1,$2,$3,$4,($3-$2)*$4}' OFS="\t" ${i}_ABS_sorted_q20.bed > ${i}_ABS_q20.bed
win100k_ABS=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_100k_win.bed
bedtools intersect -wa -wb -a ${win100k_ABS} -b ${i}_ABS.bed | bedtools groupby -c 8 -o sum > ${i}_ABS_100k.bed1
bedtools intersect -wa -wb -a ${win100k_ABS} -b ${i}_ABS.bed -v | awk '{print $1,$2,$3,0}' OFS="\t"> ${i}_ABS_100k.bed2
cat ${i}_ABS_100k.bed1 ${i}_ABS_100k.bed2 | sort -b -k1,1 -k2,2n -k3,3n  > ABS/genomecov/${i}_ABS_100k.bed
