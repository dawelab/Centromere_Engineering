#!/bin/bash
#SBATCH --job-name=build_index                     
#SBATCH --partition=batch		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4		                       
#SBATCH --mem=400gb			                               
#SBATCH --time=168:00:00  		                          
#SBATCH --output=trim_adaptor.out			  
#SBATCH --error=trim_adaptor.err

ml BWA/0.7.17-GCCcore-11.3.0
cd /scratch/yz77862/ABS_PacBio_version1

ABS_assembly=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa
bwa index ${ABS_assembly}
