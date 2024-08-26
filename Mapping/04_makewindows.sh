ml BEDTools
genome_fai=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa.fai
#Only extract the chr size
head ${genome_fai} > genome_size
bedtools makewindows -g genome_size -w 100000 > AbsGenomePBHIFI_version_1_100k_win.bed

Mo17_fai=/scratch/yz77862/MaizeGenome/Zm-Mo17-REFERENCE-CAU-2.0_addname.fa.fai
head ${Mo17_fai} > Mo17_genome_size
bedtools makewindows -g Mo17_genome_size -w 100000 > Mo17_100k_win.bed

##W22 downloaded from maizegdb can not generate the fai file and fai file can only be downloaded in the website 
W22_fai=/scratch/yz77862/MaizeGenome/Zm-W22-REFERENCE-NRGENE-2.0.chr_scaffolds.fa.gz.fai
head ${W22_fai} > W22_genome_size 
bedtools makewindows -g W22_genome_size -w 100000 > W22_100k_win.bed
