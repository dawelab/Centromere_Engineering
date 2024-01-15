cd /scratch/yz77862/ABS_PacBio_version1
ml BLAST+
makeblastdb -in AbsGenomePBHIFI_version_1.fa -input_type fasta -dbtype nucl -out AbsGenomePBHIFI_version_1.fa_blastdb
blastn -query pACH25.fasta -db AbsGenomePBHIFI_version_1.fa_blastdb -out ABS_PACBIO_blast_pACH25_result.xls -task blastn -outfmt 6
blastn -query ABS.fasta -db AbsGenomePBHIFI_version_1.fa_blastdb -out ABS_PACBIO_blast_ABS_result.xls -task blastn -outfmt 6
