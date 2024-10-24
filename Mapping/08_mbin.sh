#!/bin/bash  
#SBATCH --job-name=EMbin_mapping              
#SBATCH --partition=batch   
#SBATCH --nodes=1                   
#SBATCH --ntasks=1               
#SBATCH --cpus-per-task=11            
#SBATCH --mem=400G
#SBATCH --ntasks-per-node=1
#SBATCH --time=030:00:00              
#SBATCH --output=EMbin_mapping.out           
#SBATCH --error=EMbin_mapping.err

ml CGmapTools/0.1.2-foss-2022a
cd /scratch/yz77862/EMmethyl

for GENOME in KD4315-2 KD4315-4 KD4315-5 KD4315-8 yz306-2 yz306-3 yz306-5;do
cgmaptools mbin -i ${GENOME}.CGmap.gz -C CG -B 10000 -c 1  > ${GENOME}.mCG.mbin.10k.data
cgmaptools mbin -i ${GENOME}.CGmap.gz -C CHG -B 10000 -c 1  > ${GENOME}.mCHG.mbin.10k.data
cgmaptools mbin -i ${GENOME}.CGmap.gz -C CHH -B 10000 -c 1  > ${GENOME}.mCHH.mbin.10k.data
done
ml CGmapTools/0.1.2-foss-2022a
GENOME=yz306-6
cgmaptools mbin -i ${GENOME}.CGmap.gz -C CG -B 500000 -c 1  > ${GENOME}.mCG.mbin.500k.data
cgmaptools mbin -i ${GENOME}.CGmap.gz -C CHG -B 500000 -c 1  > ${GENOME}.mCHG.mbin.500k.data
cgmaptools mbin -i ${GENOME}.CGmap.gz -C CHH -B 500000 -c 1  > ${GENOME}.mCHH.mbin.500k.data

