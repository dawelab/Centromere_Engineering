#!/bin/bash
#SBATCH --job-name=repeat_masker_no         
#SBATCH --partition=batch                              
#SBATCH --ntasks=1                               
#SBATCH --cpus-per-task=4                         
#SBATCH --mem=400gb                                  
#SBATCH --time=168:00:00                              
#SBATCH --output=repeat_masker_no.out     
#SBATCH --error=repeat_masker_no.err

cd /scratch/yz77862/repeatmask
ml RepeatMasker/4.1.4-foss-2022a
directory=/scratch/yz77862/repeatmask/${Genome}  ##Genome=A188,B73,postjoin/nopostjoin
library=/scratch/yz77862/repeatmask/repeats.fasta   ##Copy from Jianing Gapless aseembly paper

#For no postjoinning Genome assembly
nopostjoinning=/scratch/yz77862/Pac_bio_HIFI/ftp.genome.arizona.edu/hifiasm/Zmays_Abs4-2cells_hifiasm_l0.bp.p_ctg.fa
RepeatMasker -gff -parallel 30 -dir ${directory} -lib ${library} -nolow ${nopostjoinning}

#For postjoinning Genome assembly
postjoinning=/scratch/yz77862/pac-hifi-2/ftp.genome.arizona.edu/ragtag_assembly/Zmays_Abs4-2cells-l0.bp.p_ctg.fa
RepeatMasker -gff -parallel 30 -dir ${directory} -lib ${library} -nolow  ${postjoinning}

#For reference genome A188
A188=/scratch/yz77862/pac-hifi-2/ftp.genome.arizona.edu/A188_CUTNTag/Zm-A188-REFERENCE-KSU-1.0.fa
RepeatMasker -gff -parallel 30 -dir ${directory} -lib ${library} -nolow  -s ${A188}

#For reference genome B73
B73=/scratch/yz77862/pac-hifi-2/ftp.genome.arizona.edu/B73_v5_CUTNTag/Zm-B73-REFERENCE-NAM-5.0.fa
RepeatMasker -gff -parallel 30 -dir ${directory} -lib ${library} -nolow  ${B73}
