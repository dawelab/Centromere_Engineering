############################################################
###         Create directories for mapping             #####
############################################################
mkdir -p /scratch/yz77862/CUTnTag/
cd /scratch/yz77862/CUTnTag/
for i in ABS Mo17 W22;do #For different mapping 
  for j in SAM BAM BAMQ20 BED BEDQ20 genomecov ratio TDF shell;do
  mkdir -p ${i}/${j}
  done
done
list=/scratch/yz77862/CUTnTag/data/list
while read i;do
out=/scratch/yz77862/CUTnTag/shell/${i}_mapping.sh
echo '#!/bin/bash' >> ${out}
echo "#SBATCH --job-name=${i}_mapping" >> ${out}                 
echo "#SBATCH --partition=batch" >> ${out}   		                            
echo "#SBATCH --ntasks=1" >> ${out}   			                            
echo "#SBATCH --cpus-per-task=4" >> ${out}   		                       
echo "#SBATCH --mem=400gb" >> ${out}   			                               
echo "#SBATCH --time=168:00:00" >> ${out}     		                          
echo "#SBATCH --output=${i}_normalization.out" >> ${out}   			  
echo "#SBATCH --error=${i}_normalization.err" >> ${out}
echo " " >> ${out} 
echo "ml BWA/0.7.17-GCCcore-11.3.0" >> ${out}  
echo "ml BEDTools/2.29.2-GCC-8.3.0" >> ${out}  
echo "ml SAMtools/1.16.1-GCC-11.3.0" >> ${out}  
echo "ml IGV/2.16.1-Java-11" >> ${out} 
echo " " >> ${out} 
#The main working directory
echo "cd /scratch/yz77862/CUTnTag " >> ${out} 
echo "output_dir=/scratch/yz77862/CUTnTag/output" >> ${out} 
#######################################################
#####Set up the value for different mapping genome#####
#######################################################
echo "ABS_genome=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa" >> ${out}   
echo "W22_genome=/scratch/yz77862/MaizeGenome/Zm-W22-REFERENCE-NRGENE-2.0.fa"  >> ${out}   
echo "Mo17_genome=/scratch/yz77862/MaizeGenome/Zm-Mo17-REFERENCE-CAU-2.0_addname.fa"  >> ${out}  
#######################################################
#####       Set up the value for input            #####
#######################################################
echo "fastq1=/scratch/yz77862/CUTnTag/data/${i}_R1_001_val_1.fq.gz" >> ${out} 
echo "fastq2=/scratch/yz77862/CUTnTag/data/${i}_R2_001_val_2.fq.gz" >> ${out} 
#######################################################
#####       Map to different genomes             #####
#######################################################
echo "bwa mem \${ABS_genome} \${fastq1} \${fastq2} -M -t 24  > \${output_dir}/ABS/SAM/${i}_ABS.sam" >> ${out}  
echo "bwa mem \${W22_genome} \${fastq1} \${fastq2} -M -t 24  > \${output_dir}/W22/SAM/${i}_W22.sam" >> ${out} 
echo "bwa mem \${Mo17_genome} \${fastq1} \${fastq2} -M -t 24 > \${output_dir}/Mo17/SAM/${i}_Mo17.sam" >> ${out}  
#######################################################
#####       Convert SAM to BAM and sort           #####
#######################################################
echo "samtools view -b -F 4 -S \${output_dir}/ABS/SAM/${i}_ABS.sam -o \${output_dir}/ABS/BAM/${i}_ABS.bam" >> ${out}  
echo "samtools view -b -F 4 -S \${output_dir}/W22/SAM/${i}_W22.sam -o \${output_dir}/W22/BAM/${i}_W22.bam" >> ${out}  
echo "samtools view -b -F 4 -S \${output_dir}/Mo17/SAM/${i}_Mo17.sam -o \${output_dir}/Mo17/BAM/${i}_Mo17.bam" >> ${out}  
echo "samtools sort -o \${output_dir}/ABS/BAM/${i}_ABS_sorted.bam \${output_dir}/ABS/BAM/${i}_ABS.bam" >> ${out} 
echo "samtools sort -o \${output_dir}/W22/BAM/${i}_ABS_sorted.bam \${output_dir}/W22/BAM/${i}_W22.bam" >> ${out}    
echo "samtools sort -o \${output_dir}/Mo17/BAM/${i}_ABS_sorted.bam \${output_dir}/Mo17/BAM/${i}_Mo17.bam" >> ${out}    
echo "rm \${output_dir}/ABS/BAM/${i}_ABS.bam \${output_dir}/W22/BAM/${i}_W22.bam \${output_dir}/Mo17/BAM/${i}_Mo17.bam" >> ${out}  
#######################################################
#####       Filter reads lower than q20           #####
#######################################################
echo "samtools view -q 20 -o \${output_dir}/ABS/BAMQ20/${i}_ABS_sorted_q20.bam \${output_dir}/ABS/BAM/${i}_ABS_sorted.bam" >> ${out}  
echo "samtools view -q 20 -o \${output_dir}/W22/BAMQ20/${i}_W22_sorted_q20.bam \${output_dir}/W22/BAM/${i}_W22_sorted.bam" >> ${out}  
echo "samtools view -q 20 -o \${output_dir}/Mo17/BAMQ20/${i}_Mo17_sorted_q20.bam \${output_dir}/Mo17/BAM/${i}_Mo17_sorted.bam" >> ${out}  
#######################################################
#####       Create the index files                #####
#######################################################
echo "cd \${output_dir}/ABS/BAM"  >> ${out}   
echo "samtools index \${output_dir}/ABS/BAM/${i}_ABS_sorted.bam" >> ${out}  
echo "cd \${output_dir}/W22/BAM" >> ${out}   
echo "samtools index \${output_dir}/W22/BAM/${i}_W22_sorted.bam" >> ${out}   
echo "cd \${output_dir}/Mo17/BAM" >> ${out}   
echo "samtools index \${output_dir}/Mo17/BAM/${i}_Mo17_sorted.bam" >> ${out}   
echo "cd \${output_dir}/ABS/BAMQ20" >> ${out}   
echo "samtools index \${output_dir}/ABS/BAMQ20/${i}_ABS_sorted_q20.bam" >> ${out}   
echo "cd \${output_dir}/W22/BAMQ20" >> ${out}   
echo "samtools index \${output_dir}/W22/BAMQ20/${i}_W22_sorted_q20.bam" >> ${out}   
echo "cd \${output_dir}/Mo17/BAMQ20" >> ${out}   
echo "samtools index \${output_dir}/Mo17/BAMQ20/${i}_Mo17_sorted_q20.bam" >> ${out}  
#######################################################
#####                     IGVtools               #####
#######################################################
echo "igvtools count -w 100000 \${output_dir}/ABS/BAM/${i}_ABS_sorted.bam \${output_dir}/ABS/TDF/${i}_ABS_sorted_100Kb.tdf \${ABS_genome}" >> ${out} 
echo "igvtools count -w 100000 \${output_dir}/W22/BAM/${i}_W22_sorted.bam \${output_dir}/W22/TDF/${i}_W22_sorted_100Kb.tdf \${W22_genome}" >> ${out} 
echo "igvtools count -w 100000 \${output_dir}/Mo17/BAM/${i}_Mo17_sorted.bam \${output_dir}/Mo17/TDF/${i}_Mo17_sorted_100Kb.tdf \${Mo17_genome}" >> ${out} 
echo "igvtools count -w 100000 \${output_dir}/ABS/BAMQ20/${i}_ABS_sorted_q20.bam \${output_dir}/ABS/TDF/${i}_ABS_sorted_100Kb_q20.tdf  \${ABS_genome}" >> ${out} 
echo "igvtools count -w 100000 \${output_dir}/W22/BAMQ20/${i}_W22_sorted_q20.bam \${output_dir}/W22/TDF/${i}_W22_sorted_100Kb_q20.tdf  \${W22_genome}" >> ${out} 
echo "igvtools count -w 100000 \${output_dir}/Mo17/BAMQ20/${i}_Mo17_sorted_q20.bam \${output_dir}/Mo17/TDF/${i}_Mo17_sorted_100Kb_q20.tdf  \${Mo17_genome}" >> ${out} 
#######################################################
#####                  BAM to BED               #####
#######################################################
echo "bedtools genomecov -ibam \${output_dir}/ABS/BAM/${i}_ABS_sorted.bam -bg > \${output_dir}/ABS/BED/${i}_ABS_sorted.bed" >> ${out}
echo "bedtools genomecov -ibam \${output_dir}/W22/BAM/${i}_W22_sorted.bam -bg > \${output_dir}/W22/BED/${i}_W22_sorted.bed" >> ${out}
echo "bedtools genomecov -ibam \${output_dir}/Mo17/BAM/${i}_Mo17_sorted.bam -bg > \${output_dir}/Mo17/BED/${i}_W22_sorted.bed" >> ${out}
echo "bedtools genomecov -ibam \${output_dir}/ABS/BAMQ20/${i}_ABS_sorted_q20.bam -bg > \${output_dir}/ABS/BEDQ20/${i}_ABS_sorted.bed" >> ${out}
echo "bedtools genomecov -ibam \${output_dir}/W22/BAMQ20/${i}_W22_sorted_q20.bam -bg > \${output_dir}/W22/BEDQ20/${i}_W22_sorted.bed" >> ${out}
echo "bedtools genomecov -ibam \${output_dir}/Mo17/BAMQ20/${i}_Mo17_sorted_q20.bam -bg > \${output_dir}/Mo17/BEDQ20/${i}_Mo17_sorted.bed" >> ${out}
echo "awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" \${output_dir}/ABS/BED/${i}_ABS_sorted.bed > \${output_dir}/ABS/BED/${i}_ABS.bed" >> ${out}
echo "awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" \${output_dir}/W22/BED/${i}_W22_sorted.bed > \${output_dir}/W22/BED/${i}_W22.bed" >> ${out}
echo "awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" \${output_dir}/Mo17/BED/${i}_Mo17_sorted.bed > \${output_dir}/Mo17/BED/${i}_Mo17.bed" >> ${out}
echo "awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" \${output_dir}/ABS/BEDQ20/${i}_ABS_sorted.bed > \${output_dir}/ABS/BEDQ20/${i}_ABS.bed" >> ${out}
echo "awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" \${output_dir}/W22/BEDQ20/${i}_W22_sorted.bed > \${output_dir}/W22/BEDQ20/${i}_W22.bed" >> ${out}
echo "awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" \${output_dir}/Mo17/BEDQ20/${i}_Mo17_sorted.bed > \${output_dir}/Mo17/BEDQ20/${i}_Mo17.bed" >> ${out}
#######################################################
#####             100kb-window files               #####
#######################################################
echo "win100k_ABS=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_100k_win.bed" >> ${out} 
echo "win100k_W22=/scratch/yz77862/MaizeGenome/W22_100k_win.bed" >> ${out} 
echo "win100k_Mo17=/scratch/yz77862/MaizeGenome/Mo17_100k_win.bed" >> ${out} 
#######################################################
#####             100kb-win genomecov              #####
#########################################c##############
echo "bedtools intersect -wa -wb -a \${win100k_ABS} -b \${output_dir}/ABS/BED/${i}_ABS.bed | bedtools groupby -c 8 -o sum >\${output_dir}/ABS/genomecov/${i}_ABS_100k.bed1" >> ${out}
echo "bedtools intersect -wa -wb -a \${win100k_ABS} -b \${output_dir}/ABS/BED/${i}_ABS.bed -v | awk '{print \$1,\$2,\$3,0}' OFS=\"\\t\"> \${output_dir}/ABS/genomecov/${i}_ABS_100k.bed2" >> ${out} 
echo "cat output/ABS/genomecov/${i}_ABS_100k.bed1 \${output_dir}/ABS/genomecov/${i}_ABS_100k.bed2 | sort -b -k1,1 -k2,2n -k3,3n  > \${output_dir}/ABS/genomecov/${i}_ABS_100k.bed" >> ${out}
echo "rm output/ABS/genomecov/${i}_ABS_100k.bed2 \${output_dir}/ABS/genomecov/${i}_ABS_100k.bed1"  >> ${out}
echo "bedtools intersect -wa -wb -a \${win100k_W22} -b \${output_dir}/W22/BED/${i}_W22.bed | bedtools groupby -c 8 -o sum > \${output_dir}/W22/genomecov/${i}_W22_100k.bed1" >> ${out}
echo "bedtools intersect -wa -wb -a \${win100k_W22} -b \${output_dir}/W22/BED/${i}_W22.bed -v | awk '{print \$1,\$2,\$3,0}' OFS=\"\\t\"> \${output_dir}/W22/genomecov/${i}_W22_100k.bed2" >> ${out} 
echo "cat \${output_dir}/W22/genomecov/${i}_W22_100k.bed1 \${output_dir}/W22/genomecov/${i}_W22_100k.bed2 | sort -b -k1,1 -k2,2n -k3,3n  > \${output_dir}/W22/genomecov/${i}_W22_100k.bed" >> ${out}
echo "rm \${output_dir}/W22/genomecov/${i}_W22_100k.bed2 \${output_dir}/W22/genomecov/${i}_W22_100k.bed1"  >> ${out}
echo "bedtools intersect -wa -wb -a \${win100k_Mo17} -b \${output_dir}/Mo17/BED/${i}_Mo17.bed | bedtools groupby -c 8 -o sum > \${output_dir}/Mo17/genomecov/${i}_Mo17_100k.bed1" >> ${out}
echo "bedtools intersect -wa -wb -a \${win10k_Mo17} -b \${output_dir}/Mo17/BED/${i}_Mo17.bed -v | awk '{print \$1,\$2,\$3,0}' OFS=\"\\t\"> \${output_dir}/Mo17/genomecov/${i}_Mo17_10k.bed2" >> ${out} 
echo "cat \${output_dir}/Mo17/genomecov/${i}_Mo17_10k.bed1 \${output_dir}/Mo17/genomecov/${i}_Mo17_10k.bed2 | sort -b -k1,1 -k2,2n -k3,3n  > \${output_dir}/Mo17/genomecov/${i}_Mo17_10k.bed" >> ${out}
echo "rm \${output_dir}/Mo17/genomecov/${i}_Mo17_10k.bed2 \${output_dir}/Mo17/genomecov/${i}_Mo17_10k.bed1"  >> ${out}
done < <(cut -f1 ${list} | grep -v 'skip' | sort -u)
