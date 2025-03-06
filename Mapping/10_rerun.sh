list=/scratch/yz77862/cut_data/list

if [[ ! -f "$list" ]]; then
    echo "Error: File $list not found!" >&2
    exit 1
fi

while read -r i; do
    out=/scratch/yz77862/cut_data/shell_2/${i}_mapping.sh
    echo '#!/bin/bash' >> ${out}
    echo "#SBATCH --job-name=${i}_mapping" >> ${out}                 
    echo "#SBATCH --partition=batch" >> ${out}   		                            
    echo "#SBATCH --ntasks=1" >> ${out}   			                            
    echo "#SBATCH --cpus-per-task=4" >> ${out}   		                       
    echo "#SBATCH --mem=100gb" >> ${out}  # Adjusted memory request                          
    echo "#SBATCH --time=18:00:00" >> ${out} # Removed leading zero                          
    echo "#SBATCH --output=${i}_normalization.out" >> ${out}   			  
    echo "#SBATCH --error=${i}_normalization.err" >> ${out}
    echo "set -e" >> ${out}  # Exit on error
    echo "ml SAMtools" >> ${out} 
    echo "cd /scratch/yz77862/cut_data/BAM" >> ${out} 
    echo "output_dir=/scratch/yz77862/cut_data/BAM" >> ${out} 
    echo "ABS_genome=/scratch/yz77862/ABS_ver1/AbsGenomePBHIFI_version_1.fa" >> ${out}   
    echo "fastq1=/scratch/yz77862/cut_data/trimmed/${i}_1_val_1.fq" >> ${out} 
    echo "fastq2=/scratch/yz77862/cut_data/trimmed/${i}_2_val_2.fq" >> ${out} 

    # Convert, Sort, and Filter
    echo "samtools view -b -F 4 \${output_dir}/${i}_ABS.sam | samtools sort -o \${output_dir}/${i}_ABS_sorted.bam" >> ${out}  
    echo "samtools view -q 20 -o \${output_dir}/${i}_ABS_sorted_q20.bam \${output_dir}/${i}_ABS_sorted.bam" >> ${out}  

    # Index
    echo "samtools index \${output_dir}/${i}_ABS_sorted.bam" >> ${out}  

done < <(cut -f1 ${list} | grep -v 'skip' | sort -u)
