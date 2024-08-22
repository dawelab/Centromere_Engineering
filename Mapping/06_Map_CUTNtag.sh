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
echo "bwa mem \${ABS_genome} \${fastq1} \${fastq2} -M -t 24  > output/ABS/SAM/${i}_ABS.sam" >> ${out}  
echo "bwa mem \${W22_genome} \${fastq1} \${fastq2} -M -t 24  > output/W22/SAM/${i}_W22.sam" >> ${out} 
echo "bwa mem \${Mo17_genome} \${fastq1} \${fastq2} -M -t 24 > output/Mo17/SAM/${i}_Mo17.sam" >> ${out}  
#######################################################
#####       Convert SAM to BAM and sort           #####
#######################################################
echo "samtools view -b -F 4 -S output/ABS/SAM/${i}_ABS.sam -o output/ABS/BAM/${i}_ABS.bam" >> ${out}  
echo "samtools view -b -F 4 -S output/W22/SAM/${i}_W22.sam -o output/W22/BAM/${i}_W22.bam" >> ${out}  
echo "samtools view -b -F 4 -S output/Mo17/SAM/${i}_Mo17.sam -o output/Mo17/BAM/${i}_Mo17.bam" >> ${out}  
echo "samtools sort -o output/ABS/BAM/${i}_ABS_sorted.bam output/ABS/BAM/${i}_ABS.bam" >> ${out} 
echo "samtools sort -o output/W22/BAM/${i}_ABS_sorted.bam output/W22/BAM/${i}_W22.bam" >> ${out}    
echo "samtools sort -o output/Mo17/BAM/${i}_ABS_sorted.bam output/Mo17/BAM/${i}_Mo17.bam" >> ${out}    
echo "rm output/ABS/BAM/${i}_ABS.bam output/W22/BAM/${i}_W22.bam output/Mo17/BAM/${i}_Mo17.bam" >> ${out}  
#######################################################
#####       Filter reads lower than q20           #####
#######################################################
echo "samtools view -q 20 -o output/ABS/BAMQ20/${i}_ABS_sorted_q20.bam output/ABS/BAM/${i}_ABS_sorted.bam" >> ${out}  
echo "samtools view -q 20 -o output/W22/BAMQ20/${i}_W22_sorted_q20.bam output/W22/BAM/${i}_W22_sorted.bam" >> ${out}  
echo "samtools view -q 20 -o output/Mo17/BAMQ20/${i}_Mo17_sorted_q20.bam output/Mo17/BAM/${i}_Mo17_sorted.bam" >> ${out}  
#######################################################
#####       Create the index files                #####
#######################################################
echo "cd output/ABS/BAM"  >> ${out}   
echo "samtools index output/ABS/BAM/${i}_ABS_sorted.bam" >> ${out}  
echo "cd output/W22/BAM" >> ${out}   
echo "samtools index output/W22/BAM/${i}_W22_sorted.bam" >> ${out}   
echo "cd output/Mo17/BAM" >> ${out}   
echo "samtools index output/Mo17/BAM/${i}_Mo17_sorted.bam" >> ${out}   
echo "cd output/ABS/BAMQ20" >> ${out}   
echo "samtools index output/ABS/BAMQ20/${i}_ABS_sorted_q20.bam" >> ${out}   
echo "cd output/W22/BAMQ20" >> ${out}   
echo "samtools index output/W22/BAMQ20/${i}_W22_sorted_q20.bam" >> ${out}   
echo "cd output/Mo17/BAMQ20" >> ${out}   
echo "samtools index output/Mo17/BAMQ20/${i}_Mo17_sorted_q20.bam" >> ${out}  
#######################################################
#####                     IGVtools               #####
#######################################################
echo "igvtools count -w 10000 output/ABS/BAM/${i}_ABS_sorted.bam output/ABS/TDF/${i}_ABS_sorted_10Kb.tdf \${ABS_genome}" >> ${out} 
echo "igvtools count -w 10000 output/W22/BAM/${i}_W22_sorted.bam output/W22/TDF/${i}_W22_sorted_10Kb.tdf \${W22_genome}" >> ${out} 
echo "igvtools count -w 10000 output/Mo17/BAM/${i}_Mo17_sorted.bam output/Mo17/TDF/${i}_Mo17_sorted_10Kb.tdf \${Mo17_genome}" >> ${out} 
echo "igvtools count -w 10000 output/ABS/BAMQ20/${i}_ABS_sorted_q20.bam output/ABS/TDF/${i}_ABS_sorted_10Kb_q20.tdf  \${ABS_genome}" >> ${out} 
echo "igvtools count -w 10000 output/W22/BAMQ20/${i}_W22_sorted_q20.bam output/W22/TDF/${i}_W22_sorted_10Kb_q20.tdf  \${W22_genome}" >> ${out} 
echo "igvtools count -w 10000 output/Mo17/BAMQ20/${i}_Mo17_sorted_q20.bam output/Mo17/TDF/${i}_Mo17_sorted_10Kb_q20.tdf  \${Mo17_genome}" >> ${out} 
#######################################################
#####                  BAM to BED               #####
#######################################################
echo "bedtools genomecov -ibam output/ABS/BAM/${i}_ABS_sorted.bam -bg > output/ABS/BED/${i}_ABS_sorted.bed" >> ${out}
echo "bedtools genomecov -ibam output/W22/BAM/${i}_W22_sorted.bam -bg > output/W22/BED/${i}_W22_sorted.bed" >> ${out}
echo "bedtools genomecov -ibam output/Mo17/BAM/${i}_Mo17_sorted.bam -bg > output/Mo17/BED/${i}_W22_sorted.bed" >> ${out}
echo "bedtools genomecov -ibam output/ABS/BAMQ20/${i}_ABS_sorted_q20.bam -bg > output/ABS/BEDQ20/${i}_ABS_sorted.bed" >> ${out}
echo "bedtools genomecov -ibam output/W22/BAMQ20/${i}_W22_sorted_q20.bam -bg > output/W22/BEDQ20/${i}_W22_sorted.bed" >> ${out}
echo "bedtools genomecov -ibam output/Mo17/BAMQ20/${i}_Mo17_sorted_q20.bam -bg > output/Mo17/BEDQ20/${i}_Mo17_sorted.bed" >> ${out}
echo "awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" output/ABS/BED/${i}_ABS_sorted.bed > output/ABS/BED/${i}_ABS.bed" >> ${out}
echo "awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" output/W22/BED/${i}_W22_sorted.bed > output/W22/BED/${i}_W22.bed" >> ${out}
echo "awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" output/Mo17/BED/${i}_Mo17_sorted.bed > output/Mo17/BED/${i}_Mo17.bed" >> ${out}
echo "awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" output/ABS/BEDQ20/${i}_ABS_sorted.bed > output/ABS/BEDQ20/${i}_ABS.bed" >> ${out}
echo "awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" output/W22/BEDQ20/${i}_W22_sorted.bed > output/W22/BEDQ20/${i}_W22.bed" >> ${out}
echo "awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" output/Mo17/BEDQ20/${i}_Mo17_sorted.bed > output/Mo17/BEDQ20/${i}_Mo17.bed" >> ${out}
#######################################################
#####             10kb-window files               #####
#######################################################
echo "win10k_ABS=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_10k_win.bed" >> ${out} 
echo "win10k_W22=/scratch/yz77862/MaizeGenome/Zm-W22-REFERENCE-NRGENE-2.0.chr_scaffolds.10k.bed" >> ${out} 
echo "win10k_Mo17=/scratch/yz77862/MaizeGenome/Mo17_10k_win.bed" >> ${out} 
#######################################################
#####             10kb-win genomecov              #####
#########################################c##############
echo "bedtools intersect -wa -wb -a \${win10k_ABS} -b output/ABS/BED/${i}_ABS.bed | bedtools groupby -c 8 -o sum > output/ABS/genomecov/${i}_ABS_10k.bed1" >> ${out}
echo "bedtools intersect -wa -wb -a \${win10k_ABS} -b output/ABS/BED/${i}_ABS.bed -v | awk '{print \$1,\$2,\$3,0}' OFS=\"\\t\"> output/ABS/genomecov/${i}_ABS_10k.bed2" >> ${out} 
echo "cat output/ABS/genomecov/${i}_ABS_10k.bed1 output/ABS/genomecov/${i}_ABS_10k.bed2 | sort -b -k1,1 -k2,2n -k3,3n  > output/ABS/genomecov/${i}_ABS_10k.bed" >> ${out}
echo "rm output/ABS/genomecov/${i}_ABS_10k.bed2 output/ABS/genomecov/${i}_ABS_10k.bed1"  >> ${out}
echo "bedtools intersect -wa -wb -a \${win10k_W22} -b output/W22/BED/${i}_W22.bed | bedtools groupby -c 8 -o sum > output/W22/genomecov/${i}_W22_10k.bed1" >> ${out}
echo "bedtools intersect -wa -wb -a \${win10k_W22} -b output/W22/BED/${i}_W22.bed -v | awk '{print \$1,\$2,\$3,0}' OFS=\"\\t\"> output/W22/genomecov/${i}_W22_10k.bed2" >> ${out} 
echo "cat output/W22/genomecov/${i}_W22_10k.bed1 output/W22/genomecov/${i}_W22_10k.bed2 | sort -b -k1,1 -k2,2n -k3,3n  > output/W22/genomecov/${i}_W22_10k.bed" >> ${out}
echo "rm output/W22/genomecov/${i}_W22_10k.bed2 output/W22/genomecov/${i}_W22_10k.bed1"  >> ${out}
echo "bedtools intersect -wa -wb -a \${win10k_Mo17} -b output/Mo17/BED/${i}_Mo17.bed | bedtools groupby -c 8 -o sum > output/Mo17/genomecov/${i}_Mo17_10k.bed1" >> ${out}
echo "bedtools intersect -wa -wb -a \${win10k_Mo17} -b output/Mo17/BED/${i}_Mo17.bed -v | awk '{print \$1,\$2,\$3,0}' OFS=\"\\t\"> output/Mo17/genomecov/${i}_Mo17_10k.bed2" >> ${out} 
echo "cat output/Mo17/genomecov/${i}_Mo17_10k.bed1 output/Mo17/genomecov/${i}_Mo17_10k.bed2 | sort -b -k1,1 -k2,2n -k3,3n  > output/Mo17/genomecov/${i}_Mo17_10k.bed" >> ${out}
echo "rm output/Mo17/genomecov/${i}_Mo17_10k.bed2 output/Mo17/genomecov/${i}_Mo17_10k.bed1"  >> ${out}
done < <(cut -f1 ${list} | grep -v 'skip' | sort -u)
