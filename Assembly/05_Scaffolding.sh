mkdir -p /scratch/yz77862/scaffold
for i in A188_mask A188_unmask B73_mask B73_unmask;do
     for j in mask_post unmask_post mask_nopost unmask_nopost;do
mkdir -p /scratch/yz77862/scaffold/${i}_${j}
cd /scratch/yz77862/scaffold/${i}_${j}
out=/scratch/yz77862/scaffold/${i}_${j}/scaffold_${i}_${j}.sh

echo '#!/bin/bash' >> ${out}
echo "#SBATCH --job-name=${i}_${j}" >> ${out}
echo "#SBATCH --partition=batch" >> ${out}
echo "#SBATCH --ntasks=1" >> ${out}
echo "#SBATCH --mem=400G" >> ${out}
echo "#SBATCH --time=25:00:00" >> ${out}
echo "#SBATCH --export=NONE" >> ${out}
echo "#SBATCH --output=${i}_${j}.out" >> ${out}
echo "#SBATCH --error=${i}_${j}.err" >> ${out}
echo "#SBATCH --mail-user=yz77862@uga.edu"  >> ${out}
echo "#SBATCH --mail-type=BEGIN"  >> ${out}
echo " " >> ${out}
echo "ml RagTag/2.1.0" >> ${out}
echo "cd /scratch/yz77862/scaffold/${i}_${j}" >> ${out}
echo " " >> ${out}
echo "#Create the factor for different combination" >> ${out}
echo "A188_mask=/scratch/yz77862/repeatmask/A188/Zm-A188-REFERENCE-KSU-1.0.fa.masked" >> ${out}
echo "A188_unmask=/scratch/yz77862/pac-hifi-2/ftp.genome.arizona.edu/A188_CUTNTag/Zm-A188-REFERENCE-KSU-1.0.fa" >> ${out}
echo "B73_mask=/scratch/yz77862/repeatmask/B73/Zm-B73-REFERENCE-NAM-5.0.fa.masked" >> ${out}
echo "B73_unmask=/scratch/yz77862/pac-hifi-2/ftp.genome.arizona.edu/B73_v5_CUTNTag/Zm-B73-REFERENCE-NAM-5.0.fa" >> ${out}
echo " " >> ${out}
echo "mask_post=/scratch/yz77862/repeatmask/post/Zmays_Abs4-2cells-l0.bp.p_ctg.fa.masked" >> ${out}
echo "unmask_post=/scratch/yz77862/pac-hifi-2/ftp.genome.arizona.edu/ragtag_assembly/Zmays_Abs4-2cells-l0.bp.p_ctg.fa" >> ${out}
echo "mask_nopost=/scratch/yz77862/repeatmask/nopost/Zmays_Abs4-2cells_hifiasm_l0.bp.p_ctg.fa.masked" >> ${out}
echo "unmask_nopost=/scratch/yz77862/Pac_bio_HIFI/ftp.genome.arizona.edu/hifiasm/Zmays_Abs4-2cells_hifiasm_l0.bp.p_ctg.fa" >> ${out}
echo "ragtag.py scaffold \${${i}} \${${j}} " >> ${out}
done
    done
