#!/bin/bash
#SBATCH --job-name=read_extract                    
#SBATCH --partition=highmem_p		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4		                       
#SBATCH --mem=800gb			                               
#SBATCH --time=168:00:00  		                          
#SBATCH --output=read_extract.out			  
#SBATCH --error=read_extract.err


ml seqtk/1.3-GCC-11.3.0
ml BEDTools/2.29.2-GCC-8.3.0
input_bed=/scratch/yz77862/ABS_PacBio_version1/simulated_positive_region.bed
input_fasta=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa
output_fasta=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_read_sim.fa
output_fastq=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_read_sim.fastq

bedtools getfasta -fi ${input_fasta} -bed ${input_bed} -fo ${output_fasta}
seqtk seq -F I ${output_fasta} > ${output_fastq}
