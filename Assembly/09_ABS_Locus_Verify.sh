ABS_genome=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa
ABS_genome_blastdb=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa_blastdb
ptg000016l=/scratch/yz77862/ABS_PacBio_version1/ABSLocus_Assembly/ptg000016l.fa
ptg000081l=/scratch/yz77862/ABS_PacBio_version1/ABSLocus_Assembly/ptg000081l.fa
ptg000513l=/scratch/yz77862/ABS_PacBio_version1/ABSLocus_Assembly/ptg000513l.fa
ptg000174l=/scratch/yz77862/ABS_PacBio_version1/ABSLocus_Assembly/ptg000174l.fa

#use minimap to generate the aligment files, it can tell us the orientation of contigs
ml minimap2
minimap2 -cx asm5 ${ptg000016l} ${ABS_genome} > ptg000016l_ABS.paf
minimap2 -cx asm5 ${ptg000081l} ${ABS_genome} > ptg000081l_ABS.paf 
minimap2 -cx asm5 ${ptg000513l} ${ABS_genome} > ptg000513l_ABS.paf 
minimap2 -cx asm5 ${ptg000174l} ${ABS_genome} > ptg000174l_ABS.paf 

minimap2 -cx asm5 ${ptg000016l} ${ptg000081l} > ptg000016l_ptg000081l.paf 
minimap2 -cx asm5 ${ptg000016l} ${ptg000513l} > ptg000016l_ptg000513l.paf 
minimap2 -cx asm5 ${ptg000016l} ${ptg000174l} > ptg000016l_ptg000174l.paf 
minimap2 -cx asm5 ${ptg000081l} ${ptg000513l} > ptg000081l_ptg000513l.paf 
minimap2 -cx asm5 ${ptg000081l} ${ptg000174l} > ptg000081l_ptg000174l.paf 
minimap2 -cx asm5 ${ptg000513l} ${ptg000174l} > ptg000513l_ptg000174l.paf 

ml BLAST+
blastn -query ${ptg000016l} -db ${ABS_genome_blastdb} -out ptg000016l_blast_ABS_result.xls -task blastn -outfmt 6
blastn -query ${ptg000081l} -db ${ABS_genome_blastdb} -out ptg000081l_blast_ABS_result.xls -task blastn -outfmt 6
blastn -query ${ptg000513l} -db ${ABS_genome_blastdb} -out ptg000513l_blast_ABS_result.xls -task blastn -outfmt 6
blastn -query ${ptg000174l} -db ${ABS_genome_blastdb} -out ptg000174l_blast_ABS_result.xls -task blastn -outfmt 6
