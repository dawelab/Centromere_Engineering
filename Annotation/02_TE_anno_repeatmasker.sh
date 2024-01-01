#!/bin/bash
#SBATCH --job-name=EDTA
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --mem=400G
#SBATCH --time=168:00:00
#SBATCH --export=NONE
#SBATCH --output=repeatmakser.out
#SBATCH --error=repeatmakser.err

cd /scratch/yz77862/ABS_PacBio_version1
ml RepeatMasker/4.1.5-foss-2022a

genome=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa
cds=/scratch/yz77862/B73v5_genome/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.cds.fa

RepeatMasker -q -nolow -species Zea_mays -no_is ${genome}
