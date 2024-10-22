#!/bin/bash  
#SBATCH --job-name=EMbin_mapping              
#SBATCH --partition=batch   
#SBATCH --nodes=1                   
#SBATCH --ntasks=7               
#SBATCH --cpus-per-task=18            
#SBATCH --mem=400G
#SBATCH --ntasks-per-node=1
#SBATCH --time=030:00:00              
#SBATCH --output=${INPUT}_fq_bam.out           
#SBATCH --error=${INPUT}_fq_bam.err

ml CGmapTools/0.1.2-foss-2022a
cd /scratch/yz77862/EMmethyl

for GENOME in KD4315-2 KD4315-4 KD4315-5 KD4315-8 yz306-2 yz306-3 yz306-5 yz306-6;do
cgmaptools mbin -i ${GENOME}.CGmap.gz -CG -B 500000 -c 1  > ${GENOME}.mCG.mbin.500k.data
cgmaptools mbin -i ${GENOME}.CGmap.gz -CHG -B 500000 -c 1  > ${GENOME}.mCHG.mbin.500k.data
cgmaptools mbin -i ${GENOME}.CGmap.gz -CHH -B 500000 -c 1  > ${GENOME}.mCHH.mbin.500k.data
done
