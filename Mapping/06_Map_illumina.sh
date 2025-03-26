############################################################
###         Create directories for mapping             #####
############################################################
mkdir -p /scratch/yz77862/illumina_neo4Ls/
cd /scratch/yz77862/illumina_neo4Ls/output
for i in ABS Mo17 W22; do
  for j in SAM BAM BAMQ20 BED BEDQ20 genomecov ratio TDF; do
    mkdir -p ${i}/${j}
  done
done
mkdir -p /scratch/yz77862/illumina_neo4Ls/shell/
list=/scratch/yz77862/illumina_neo4Ls/data/list

while read i; do
  out=/scratch/yz77862/illumina_neo4Ls/shell/${i}_mapping.sh
  echo '#!/bin/bash' > ${out}
  echo "#SBATCH --job-name=${i}_mapping" >> ${out}
  echo "#SBATCH --partition=batch" >> ${out}
  echo "#SBATCH --ntasks=1" >> ${out}
  echo "#SBATCH --cpus-per-task=4" >> ${out}
  echo "#SBATCH --mem=400gb" >> ${out}
  echo "#SBATCH --time=168:00:00" >> ${out}
  echo "#SBATCH --output=${i}_normalization.out" >> ${out}
  echo "#SBATCH --error=${i}_normalization.err" >> ${out}
  echo "" >> ${out}
  echo "ml BWA/0.7.17-GCCcore-11.3.0" >> ${out}
  echo "ml BEDTools/2.29.2-GCC-8.3.0" >> ${out}
  echo "ml SAMtools/1.16.1-GCC-11.3.0" >> ${out}
  echo "ml IGV/2.16.1-Java-11" >> ${out}
  echo "" >> ${out}

  echo "cd /scratch/yz77862/illumina_neo4Ls/output" >> ${out}
  echo "output_dir=/scratch/yz77862/illumina_neo4Ls/output" >> ${out}
  echo "ABS_genome=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa" >> ${out}
  echo "W22_genome=/scratch/yz77862/MaizeGenome/Zm-W22-REFERENCE-NRGENE-2.0.fa" >> ${out}
  echo "Mo17_genome=/scratch/yz77862/MaizeGenome/Zm-Mo17-REFERENCE-CAU-2.0_addname.fa" >> ${out}
  echo "fastq1=/scratch/yz77862/illumina_neo4Ls/data/${i}_R1_001_val_1.fq.gz" >> ${out}
  echo "fastq2=/scratch/yz77862/illumina_neo4Ls/data/${i}_R2_001_val_2.fq.gz" >> ${out}

  echo "bwa mem \${ABS_genome} \${fastq1} \${fastq2} -M -t 24 > \${output_dir}/ABS/SAM/${i}_ABS.sam" >> ${out}
  echo "bwa mem \${W22_genome} \${fastq1} \${fastq2} -M -t 24 > \${output_dir}/W22/SAM/${i}_W22.sam" >> ${out}
  echo "bwa mem \${Mo17_genome} \${fastq1} \${fastq2} -M -t 24 > \${output_dir}/Mo17/SAM/${i}_Mo17.sam" >> ${out}

  echo "samtools view -b -F 4 \${output_dir}/ABS/SAM/${i}_ABS.sam -o \${output_dir}/ABS/BAM/${i}_ABS.bam" >> ${out}
  echo "samtools view -b -F 4 \${output_dir}/W22/SAM/${i}_W22.sam -o \${output_dir}/W22/BAM/${i}_W22.bam" >> ${out}
  echo "samtools view -b -F 4 \${output_dir}/Mo17/SAM/${i}_Mo17.sam -o \${output_dir}/Mo17/BAM/${i}_Mo17.bam" >> ${out}

  echo "samtools sort -o \${output_dir}/ABS/BAM/${i}_ABS_sorted.bam \${output_dir}/ABS/BAM/${i}_ABS.bam" >> ${out}
  echo "samtools sort -o \${output_dir}/W22/BAM/${i}_W22_sorted.bam \${output_dir}/W22/BAM/${i}_W22.bam" >> ${out}
  echo "samtools sort -o \${output_dir}/Mo17/BAM/${i}_Mo17_sorted.bam \${output_dir}/Mo17/BAM/${i}_Mo17.bam" >> ${out}
  echo "rm \${output_dir}/ABS/BAM/${i}_ABS.bam \${output_dir}/W22/BAM/${i}_W22.bam \${output_dir}/Mo17/BAM/${i}_Mo17.bam" >> ${out}

  echo "samtools view -q 20 -o \${output_dir}/ABS/BAMQ20/${i}_ABS_sorted_q20.bam \${output_dir}/ABS/BAM/${i}_ABS_sorted.bam" >> ${out}
  echo "samtools view -q 20 -o \${output_dir}/W22/BAMQ20/${i}_W22_sorted_q20.bam \${output_dir}/W22/BAM/${i}_W22_sorted.bam" >> ${out}
  echo "samtools view -q 20 -o \${output_dir}/Mo17/BAMQ20/${i}_Mo17_sorted_q20.bam \${output_dir}/Mo17/BAM/${i}_Mo17_sorted.bam" >> ${out}

  for genome in ABS W22 Mo17; do
    echo "samtools index \${output_dir}/${genome}/BAM/${i}_${genome}_sorted.bam" >> ${out}
    echo "samtools index \${output_dir}/${genome}/BAMQ20/${i}_${genome}_sorted_q20.bam" >> ${out}
  done

  echo "igvtools count -w 100000 \${output_dir}/ABS/BAM/${i}_ABS_sorted.bam \${output_dir}/ABS/TDF/${i}_ABS_sorted_100Kb.tdf \${ABS_genome}" >> ${out}
  echo "igvtools count -w 100000 \${output_dir}/W22/BAM/${i}_W22_sorted.bam \${output_dir}/W22/TDF/${i}_W22_sorted_100Kb.tdf \${W22_genome}" >> ${out}
  echo "igvtools count -w 100000 \${output_dir}/Mo17/BAM/${i}_Mo17_sorted.bam \${output_dir}/Mo17/TDF/${i}_Mo17_sorted_100Kb.tdf \${Mo17_genome}" >> ${out}
  echo "igvtools count -w 100000 \${output_dir}/ABS/BAMQ20/${i}_ABS_sorted_q20.bam \${output_dir}/ABS/TDF/${i}_ABS_sorted_100Kb_q20.tdf \${ABS_genome}" >> ${out}
  echo "igvtools count -w 100000 \${output_dir}/W22/BAMQ20/${i}_W22_sorted_q20.bam \${output_dir}/W22/TDF/${i}_W22_sorted_100Kb_q20.tdf \${W22_genome}" >> ${out}
  echo "igvtools count -w 100000 \${output_dir}/Mo17/BAMQ20/${i}_Mo17_sorted_q20.bam \${output_dir}/Mo17/TDF/${i}_Mo17_sorted_100Kb_q20.tdf \${Mo17_genome}" >> ${out}

  echo "bedtools genomecov -ibam \${output_dir}/ABS/BAM/${i}_ABS_sorted.bam -bg > \${output_dir}/ABS/BED/${i}_ABS_sorted.bed" >> ${out}
  echo "bedtools genomecov -ibam \${output_dir}/W22/BAM/${i}_W22_sorted.bam -bg > \${output_dir}/W22/BED/${i}_W22_sorted.bed" >> ${out}
  echo "bedtools genomecov -ibam \${output_dir}/Mo17/BAM/${i}_Mo17_sorted.bam -bg > \${output_dir}/Mo17/BED/${i}_Mo17_sorted.bed" >> ${out}

  echo "bedtools genomecov -ibam \${output_dir}/ABS/BAMQ20/${i}_ABS_sorted_q20.bam -bg > \${output_dir}/ABS/BEDQ20/${i}_ABS_sorted.bed" >> ${out}
  echo "bedtools genomecov -ibam \${output_dir}/W22/BAMQ20/${i}_W22_sorted_q20.bam -bg > \${output_dir}/W22/BEDQ20/${i}_W22_sorted.bed" >> ${out}
  echo "bedtools genomecov -ibam \${output_dir}/Mo17/BAMQ20/${i}_Mo17_sorted_q20.bam -bg > \${output_dir}/Mo17/BEDQ20/${i}_Mo17_sorted.bed" >> ${out}

  for genome in ABS W22 Mo17; do
    echo "awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" \${output_dir}/${genome}/BED/${i}_${genome}_sorted.bed > \${output_dir}/${genome}/BED/${i}_${genome}.bed" >> ${out}
    echo "awk '{print \$1,\$2,\$3,\$4,(\$3-\$2)*\$4}' OFS=\"\\t\" \${output_dir}/${genome}/BEDQ20/${i}_${genome}_sorted.bed > \${output_dir}/${genome}/BEDQ20/${i}_${genome}.bed" >> ${out}
  done

  echo "win100k_ABS=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_100k_win.bed" >> ${out}
  echo "win100k_W22=/scratch/yz77862/MaizeGenome/W22_100k_win.bed" >> ${out}
  echo "win100k_Mo17=/scratch/yz77862/MaizeGenome/Mo17_100k_win.bed" >> ${out}

  for genome in ABS W22 Mo17; do
    echo "bedtools intersect -wa -wb -a \${win100k_${genome}} -b \${output_dir}/${genome}/BED/${i}_${genome}.bed | bedtools groupby -c 8 -o sum > \${output_dir}/${genome}/genomecov/${i}_${genome}_100k.bed1" >> ${out}
    echo "bedtools intersect -wa -wb -a \${win100k_${genome}} -b \${output_dir}/${genome}/BED/${i}_${genome}.bed -v | awk '{print \$1,\$2,\$3,0}' OFS=\"\\t\" > \${output_dir}/${genome}/genomecov/${i}_${genome}_100k.bed2" >> ${out}
    echo "cat \${output_dir}/${genome}/genomecov/${i}_${genome}_100k.bed1 \${output_dir}/${genome}/genomecov/${i}_${genome}_100k.bed2 | sort -b -k1,1 -k2,2n -k3,3n > \${output_dir}/${genome}/genomecov/${i}_${genome}_100k.bed" >> ${out}
    echo "rm \${output_dir}/${genome}/genomecov/${i}_${genome}_100k.bed1 \${output_dir}/${genome}/genomecov/${i}_${genome}_100k.bed2" >> ${out}
  done

done < <(cut -f1 ${list} | grep -v 'skip' | sort -u)
