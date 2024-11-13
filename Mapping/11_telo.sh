#!/bin/bash
#SBATCH --job-name=build_index                     
#SBATCH --partition=batch		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4		                       
#SBATCH --mem=400gb			                               
#SBATCH --time=008:00:00  		                          
#SBATCH --output=trim_adaptor.out			  
#SBATCH --error=trim_adaptor.err

cd /scratch/yz77862/work_illu

ml BWA/0.7.17-GCCcore-11.3.0  
ml BEDTools/2.29.2-GCC-8.3.0
ml SAMtools/1.16.1-GCC-11.3.0
ml IGV/2.16.1-Java-11

win100k_ABS=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_100k_win.bed
win100k_W22=/scratch/yz77862/MaizeGenome/W22_100k_win.bed
win100k_Mo17=/scratch/yz77862/MaizeGenome/Mo17_100k_win.bed 

ABS_genome=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa  
#17-4-2-KAPA 4-3-KAPA 7-TRI-3-KAPA YZ306-1-KAPA YZ306-2-CENH3-1 YZ306-2-CENH3-2 YZ306-2-IgG-1 YZ306-2-IgG-2
cd /scratch/yz77862/work
for i in *_ABS_sorted.bam;do
bedtools coverage -a  ${win100k_ABS} -b ${i}  -counts > ${i}_read_counts_100kb.txt
done

for i in *_Mo17_sorted.bam;do
bedtools coverage -a  ${win100k_Mo17} -b ${i}  -counts > ${i}_read_counts_100kb.txt
done

for i in *_W22_sorted.bam;do
bedtools coverage -a  ${win100k_W22} -b ${i}  -counts > ${i}_read_counts_100kb.txt
done

