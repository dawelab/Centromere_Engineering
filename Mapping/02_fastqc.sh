#Fastqc
out=/scratch/yz77862/fastqc/illumina/output
ml FastQC/0.11.9-Java-11 #Only one version in sapelo2
cd /scratch/yz77862/fastqc/illumina/data
fastqc -o ${out} *.gz -t 12 
