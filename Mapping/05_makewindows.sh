ml BEDTools
genome_fai=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa.fai
#Only extract the chr size
head ${genome_fai} > genome_size
bedtools makewindows -g genome_size -w 10000 > AbsGenomePBHIFI_version_1_10k_win.bed
bedtools makewindows -g genome_size -w 25000 > AbsGenomePBHIFI_version_1_25k_win.bed
bedtools makewindows -g genome_size -w 50000 > AbsGenomePBHIFI_version_1_50k_win.bed
bedtools makewindows -g genome_size -w 100000 > AbsGenomePBHIFI_version_1_100k_win.bed
