#!/bin/bash
#SBATCH --job-name=VCF      
#SBATCH --partition=batch                              
#SBATCH --ntasks=1                               
#SBATCH --cpus-per-task=4                         
#SBATCH --mem=400gb                                  
#SBATCH --time=168:00:00                              
#SBATCH --output=vcf.out     
#SBATCH --error=vcf.err

mkdir -p  /scratch/yz77862/illumina_neo4Ls/output/ABS/VCF
output_dir= /scratch/yz77862/illumina_neo4Ls/output/ABS/VCF
ml BCFtools/1.6-foss-2022a
cd /scratch/yz77862/illumina_neo4Ls/output/ABS/BAM
ABS_assembly=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa
for i in *.sorted.bam;do 
bcftools mpileup -d 100000 -f ${ABS_assembly} ${i} | bcftools call -c >  ${output_dir}/${i}.vcf
done
