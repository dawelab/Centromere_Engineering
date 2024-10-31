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
#######################################################
#####       Set up the value for input            #####
#######################################################
for i in 
fastq1=/scratch/yz77862/work_illu/30-1097707915_chr11-cuttag-KAPA/
fastq2=/scratch/yz77862/work_illu/30-1097707915_chr11-cuttag-KAPA/
#######################################################
#####       Map to different genomes             #####
#######################################################
bwa mem \${ABS_genome} \${fastq1} \${fastq2} -M -t 24  > \${output_dir}/ABS/SAM/${i}_ABS.sam 
bwa mem \${W22_genome} \${fastq1} \${fastq2} -M -t 24  > \${output_dir}/W22/SAM/${i}_W22.sam
bwa mem \${Mo17_genome} \${fastq1} \${fastq2} -M -t 24 > \${output_dir}/Mo17/SAM/${i}_Mo17.sam 
#######################################################
#####       Convert SAM to BAM and sort           #####
#######################################################
samtools view -b -F 4 -S \${output_dir}/ABS/SAM/${i}_ABS.sam -o \${output_dir}/ABS/BAM/${i}_ABS.bam 
samtools view -b -F 4 -S \${output_dir}/W22/SAM/${i}_W22.sam -o \${output_dir}/W22/BAM/${i}_W22.bam 
samtools view -b -F 4 -S \${output_dir}/Mo17/SAM/${i}_Mo17.sam -o \${output_dir}/Mo17/BAM/${i}_Mo17.bam 
samtools sort -o \${output_dir}/ABS/BAM/${i}_ABS_sorted.bam \${output_dir}/ABS/BAM/${i}_ABS.bam
samtools sort -o \${output_dir}/W22/BAM/${i}_ABS_sorted.bam \${output_dir}/W22/BAM/${i}_W22.bam   
samtools sort -o \${output_dir}/Mo17/BAM/${i}_ABS_sorted.bam \${output_dir}/Mo17/BAM/${i}_Mo17.bam   
rm \${output_dir}/ABS/BAM/${i}_ABS.bam \${output_dir}/W22/BAM/${i}_W22.bam \${output_dir}/Mo17/BAM/${i}_Mo17.bam 
#######################################################
#####       Filter reads lower than q20           #####
#######################################################
samtools view -q 20 -o \${output_dir}/ABS/BAMQ20/${i}_ABS_sorted_q20.bam \${output_dir}/ABS/BAM/${i}_ABS_sorted.bam 
samtools view -q 20 -o \${output_dir}/W22/BAMQ20/${i}_W22_sorted_q20.bam \${output_dir}/W22/BAM/${i}_W22_sorted.bam 
samtools view -q 20 -o \${output_dir}/Mo17/BAMQ20/${i}_Mo17_sorted_q20.bam \${output_dir}/Mo17/BAM/${i}_Mo17_sorted.bam 
#######################################################
#####       Create the index files                #####
#######################################################
cd \${output_dir}/ABS/BAM
samtools index \${output_dir}/ABS/BAM/${i}_ABS_sorted.bam 
cd \${output_dir}/W22/BAM  
samtools index \${output_dir}/W22/BAM/${i}_W22_sorted.bam  
cd \${output_dir}/Mo17/BAM  
samtools index \${output_dir}/Mo17/BAM/${i}_Mo17_sorted.bam  
cd \${output_dir}/ABS/BAMQ20  
samtools index \${output_dir}/ABS/BAMQ20/${i}_ABS_sorted_q20.bam  
cd \${output_dir}/W22/BAMQ20  
samtools index \${output_dir}/W22/BAMQ20/${i}_W22_sorted_q20.bam  
cd \${output_dir}/Mo17/BAMQ20  
samtools index \${output_dir}/Mo17/BAMQ20/${i}_Mo17_sorted_q20.bam 
#######################################################
#####                     IGVtools               #####
#######################################################
igvtools count -w 100000 \${output_dir}/ABS/BAM/${i}_ABS_sorted.bam \${output_dir}/ABS/TDF/${i}_ABS_sorted_100Kb.tdf \${ABS_genome}
igvtools count -w 100000 \${output_dir}/W22/BAM/${i}_W22_sorted.bam \${output_dir}/W22/TDF/${i}_W22_sorted_100Kb.tdf \${W22_genome}
igvtools count -w 100000 \${output_dir}/Mo17/BAM/${i}_Mo17_sorted.bam \${output_dir}/Mo17/TDF/${i}_Mo17_sorted_100Kb.tdf \${Mo17_genome}
igvtools count -w 100000 \${output_dir}/ABS/BAMQ20/${i}_ABS_sorted_q20.bam \${output_dir}/ABS/TDF/${i}_ABS_sorted_100Kb_q20.tdf  \${ABS_genome}
igvtools count -w 100000 \${output_dir}/W22/BAMQ20/${i}_W22_sorted_q20.bam \${output_dir}/W22/TDF/${i}_W22_sorted_100Kb_q20.tdf  \${W22_genome}
igvtools count -w 100000 \${output_dir}/Mo17/BAMQ20/${i}_Mo17_sorted_q20.bam \${output_dir}/Mo17/TDF/${i}_Mo17_sorted_100Kb_q20.tdf  \${Mo17_genome}
#######################################################
#####                  BAM to BED               #####
#######################################################
bedtools genomecov -ibam \${output_dir}/ABS/BAM/${i}_ABS_sorted.bam -bg > \${output_dir}/ABS/BED/${i}_ABS_sorted.bed
bedtools genomecov -ibam \${output_dir}/W22/BAM/${i}_W22_sorted.bam -bg > \${output_dir}/W22/BED/${i}_W22_sorted.bed
bedtools genomecov -ibam \${output_dir}/Mo17/BAM/${i}_Mo17_sorted.bam -bg > \${output_dir}/Mo17/BED/${i}_W22_sorted.bed
bedtools genomecov -ibam \${output_dir}/ABS/BAMQ20/${i}_ABS_sorted_q20.bam -bg > \${output_dir}/ABS/BEDQ20/${i}_ABS_sorted.bed
bedtools genomecov -ibam \${output_dir}/W22/BAMQ20/${i}_W22_sorted_q20.bam -bg > \${output_dir}/W22/BEDQ20/${i}_W22_sorted.bed
bedtools genomecov -ibam \${output_dir}/Mo17/BAMQ20/${i}_Mo17_sorted_q20.bam -bg > \${output_dir}/Mo17/BEDQ20/${i}_Mo17_sorted.bed
awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" \${output_dir}/ABS/BED/${i}_ABS_sorted.bed > \${output_dir}/ABS/BED/${i}_ABS.bed
awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" \${output_dir}/W22/BED/${i}_W22_sorted.bed > \${output_dir}/W22/BED/${i}_W22.bed
awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" \${output_dir}/Mo17/BED/${i}_Mo17_sorted.bed > \${output_dir}/Mo17/BED/${i}_Mo17.bed
awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" \${output_dir}/ABS/BEDQ20/${i}_ABS_sorted.bed > \${output_dir}/ABS/BEDQ20/${i}_ABS.bed
awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" \${output_dir}/W22/BEDQ20/${i}_W22_sorted.bed > \${output_dir}/W22/BEDQ20/${i}_W22.bed
awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" \${output_dir}/Mo17/BEDQ20/${i}_Mo17_sorted.bed > \${output_dir}/Mo17/BEDQ20/${i}_Mo17.bed
#######################################################
#####             100kb-window files               #####
#######################################################
win100k_ABS=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_100k_win.bed
win100k_W22=/scratch/yz77862/MaizeGenome/W22_100k_win.bed
win100k_Mo17=/scratch/yz77862/MaizeGenome/Mo17_100k_win.bed
#######################################################
#####             100kb-win genomecov              #####
#########################################c##############
bedtools intersect -wa -wb -a \${win100k_ABS} -b \${output_dir}/ABS/BED/${i}_ABS.bed | bedtools groupby -c 8 -o sum >\${output_dir}/ABS/genomecov/${i}_ABS_100k.bed1
bedtools intersect -wa -wb -a \${win100k_ABS} -b \${output_dir}/ABS/BED/${i}_ABS.bed -v | awk '{print \$1,\$2,\$3,0}' OFS=\"\\t\"> \${output_dir}/ABS/genomecov/${i}_ABS_100k.bed2
cat output/ABS/genomecov/${i}_ABS_100k.bed1 \${output_dir}/ABS/genomecov/${i}_ABS_100k.bed2 | sort -b -k1,1 -k2,2n -k3,3n  > \${output_dir}/ABS/genomecov/${i}_ABS_100k.bed
rm output/ABS/genomecov/${i}_ABS_100k.bed2 \${output_dir}/ABS/genomecov/${i}_ABS_100k.bed1"  >> ${out}
bedtools intersect -wa -wb -a \${win100k_W22} -b \${output_dir}/W22/BED/${i}_W22.bed | bedtools groupby -c 8 -o sum > \${output_dir}/W22/genomecov/${i}_W22_100k.bed1
bedtools intersect -wa -wb -a \${win100k_W22} -b \${output_dir}/W22/BED/${i}_W22.bed -v | awk '{print \$1,\$2,\$3,0}' OFS=\"\\t\"> \${output_dir}/W22/genomecov/${i}_W22_100k.bed2
cat \${output_dir}/W22/genomecov/${i}_W22_100k.bed1 \${output_dir}/W22/genomecov/${i}_W22_100k.bed2 | sort -b -k1,1 -k2,2n -k3,3n  > \${output_dir}/W22/genomecov/${i}_W22_100k.bed
rm \${output_dir}/W22/genomecov/${i}_W22_100k.bed2 \${output_dir}/W22/genomecov/${i}_W22_100k.bed1"  >> ${out}
bedtools intersect -wa -wb -a \${win100k_Mo17} -b \${output_dir}/Mo17/BED/${i}_Mo17.bed | bedtools groupby -c 8 -o sum > \${output_dir}/Mo17/genomecov/${i}_Mo17_100k.bed1
bedtools intersect -wa -wb -a \${win10k_Mo17} -b \${output_dir}/Mo17/BED/${i}_Mo17.bed -v | awk '{print \$1,\$2,\$3,0}' OFS=\"\\t\"> \${output_dir}/Mo17/genomecov/${i}_Mo17_10k.bed2
cat \${output_dir}/Mo17/genomecov/${i}_Mo17_10k.bed1 \${output_dir}/Mo17/genomecov/${i}_Mo17_10k.bed2 | sort -b -k1,1 -k2,2n -k3,3n  > \${output_dir}/Mo17/genomecov/${i}_Mo17_10k.bed
rm \${output_dir}/Mo17/genomecov/${i}_Mo17_10k.bed2 \${output_dir}/Mo17/genomecov/${i}_Mo17_10k.bed1"  >> ${out}
done < <(cut -f1 ${list} | grep -v 'skip' | sort -u)
