ml Trim_Galore/0.6.7-GCCcore-11.2.0
 #The data input file folder " >> ${out}
cd /scratch/yz77862/illumina_neo4Ls/data 
 #Trim adaptors " >> ${out}
trim_galore --fastqc --gzip --paired ${i}_R1_001.fastq.gz ${i}_R2_001.fastq.gz -o . -a AGATCGGAAGAGC 
