ml BEDTools
genome_fai=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa.fai
#Only extract the chr size
head ${genome_fai} > genome_size
bedtools makewindows -g genome_size -w 100000 > AbsGenomePBHIFI_version_1_100k_win.bed

Mo17_fai=/scratch/yz77862/MaizeGenome/Zm-Mo17-REFERENCE-CAU-2.0_addname.fa.fai
head ${Mo17_fai} > Mo17_genome_size
bedtools makewindows -g Mo17_genome_size -w 100000 > Mo17_100k_win.bed

W22_fai=/scratch/yz77862/MaizeGenome/
