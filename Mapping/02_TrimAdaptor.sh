echo "##Trim the adaptors" >> ${out}   
echo "#trim_galore --fastqc --gzip --paired ${i}_1.fastq ${i}_2.fastq -o . -a CTGTCTCTTATACACATCT" >> ${out}   
