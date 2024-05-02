win_10k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_10k_win.bed
win_25k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_25k_win.bed 
win_50k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_50k_win.bed
win_100k=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1_100k_win.bed

cd /scratch/yz77862/illumina_neo4Ls/output/genomecov

ml BEDTools
for i in *.bp;do
bedtools intersect -wa -wb -a ${win_10k} -b ${i} > win_10k_${i} 
bedtools intersect -wa -wb -a ${win_25k} -b ${i} > win_25k_${i} 
bedtools intersect -wa -wb -a ${win_50k} -b ${i} > win_50k_${i} 
bedtools intersect -wa -wb -a ${win_100k} -b ${i} > win_100k_${i} 
done
