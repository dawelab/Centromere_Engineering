#!/bin/bash
#SBATCH --job-name=repeatmasker
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --mem=400G
#SBATCH --time=168:00:00
#SBATCH --export=NONE
#SBATCH --output=repeatmakser.out
#SBATCH --error=repeatmakser.err

cd /scratch/yz77862/TE_annotation
ml RepeatMasker/4.1.5-foss-2022a

genome=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa
cds=/scratch/yz77862/TE_annotation/Zm-A188-REFERENCE-KSU-1.0_Zm00056aa.1.cds.fa

#RepeatMasker -q -nolow -species Zea_mays -no_is ${genome}
RepeatMasker -e ncbi -pa 18 -species Zea_mays -s -gff ${genome}
