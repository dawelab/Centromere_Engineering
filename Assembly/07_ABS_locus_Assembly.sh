cd /scratch/yz77862/ABS_PacBio_version1/ABSLocus_Assembly
nopost=/scratch/yz77862/Pac_bio_HIFI/ftp.genome.arizona.edu/hifiasm/Zmays_Abs4-2cells_hifiasm_l0.bp.p_ctg.fa
#The blast result leads to the four contigs containing ABS
#generate the bed file for extracting sequence
echo -e "ptg000016l\t0\t15717552" >> ptg000016l.bed
echo -e "ptg000081l\t0\t11585057" >> ptg000081l.bed
echo -e "ptg000513l\t0\t80825" >> ptg000513l.bed
echo -e "ptg000174l\t0\t340827" >> ptg000174l.bed

#extract the genome sequence based on the provided bed files
ml BEDTools
bedtools getfasta -fi  ${nopost} -bed ptg000016l.bed  -fo ptg000016l.fa
bedtools getfasta -fi  ${nopost} -bed ptg000081l.bed  -fo ptg000081l.fa
bedtools getfasta -fi  ${nopost} -bed ptg000513l.bed  -fo ptg000513l.fa
bedtools getfasta -fi  ${nopost} -bed ptg000174l.bed  -fo ptg000174l.fa

#use minimap to generate the aligment files, it can tell us the orientation of contigs
ml minimap2
minimap2 -cx asm5 ptg000016l.fa ptg000513l.fa > ptg000016l_ptg000513l.paf
minimap2 -cx asm5 ptg000081l.fa ptg000174l.fa > ptg000081l_ptg000174l.paf 

##use blast to generate the identity files, identity the overlapping regiion for ABS locus assembly,
#it can tell us the location we should scaffold the contigs.
ml BLAST+
makeblastdb -in ptg000016l.fa -input_type fasta -dbtype nucl -out ptg000016l.fa_blastdb
makeblastdb -in ptg000081l.fa -input_type fasta -dbtype nucl -out ptg000081l.fa_blastdb
makeblastdb -in ptg000513l.fa -input_type fasta -dbtype nucl -out ptg000513l.fa_blastdb
makeblastdb -in ptg000174l.fa -input_type fasta -dbtype nucl -out ptg000174l.fa_blastdb

blastn -query ptg000016l.fa -db ptg000513l.fa_blastdb -out ptg000016l_blast_ptg000513l_result.xls -task blastn -outfmt 6
blastn -query ptg000081l.fa -db ptg000174l.fa_blastdb -out ptg000081l_blast_ptg000174l_result.xls -task blastn -outfmt 6
blastn -query ptg000513l.fa -db ptg000174l.fa_blastdb -out ptg000513l_blast_ptg000174l_result.xls -task blastn -outfmt 6
blastn -query ptg000513l.fa -db ptg000081l.fa_blastdb -out ptg000513l_blast_ptg000081l_result.xls -task blastn -outfmt 6
