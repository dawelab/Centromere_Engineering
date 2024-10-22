mkdir -p /scratch/yz77862/mRNA/gene_guide
mkdir -p /scratch/yz77862/mRNA/gene_guide/shell
mkdir -p /scratch/yz77862/mRNA/gene_guide/round1
mkdir -p /scratch/yz77862/mRNA/gene_guide/round2

list=/scratch/yz77862/mRNA/list
while read INPUT; do

OUT=/scratch/yz77862/mRNA/gene_guide/shell/${INPUT}.sh
    echo '#!/bin/bash'  >> ${OUT} 
    echo "#SBATCH --job-name=${INPUT}_mapping"   >> ${OUT}            
    echo "#SBATCH --partition=batch"   >> ${OUT} 
    echo "#SBATCH --nodes=1"   >> ${OUT}                  
    echo "#SBATCH --ntasks=7"   >> ${OUT}              
    echo "#SBATCH --cpus-per-task=18"   >> ${OUT}          
    echo "#SBATCH --mem=400G"   >> ${OUT}
    echo "#SBATCH --ntasks-per-node=1" >> ${OUT}
    echo "#SBATCH --time=030:00:00"   >> ${OUT}             
    echo "#SBATCH --output=${INPUT}_fq_bam.out"   >> ${OUT}         
    echo "#SBATCH --error=${INPUT}_fq_bam.err"   >> ${OUT}         
    echo " "  >> ${OUT}  
    echo "ml  STAR/2.7.10b-GCC-11.3.0" >> ${OUT}  
    echo "cd /scratch/yz77862/mRNA/gene_guide/round1" >> ${OUT}r
    echo " "  >> ${OUT}
    echo "thread=18"  >> ${OUT}  
    echo "index=/scratch/yz77862/ABS_Pacbio_index"  >> ${OUT}  
    echo "read1=/scratch/yz77862/mRNA/${INPUT}_R1_001_val_1.fq.gz"  >> ${OUT}  
    echo "read2=/scratch/yz77862/mRNA/${INPUT}_R2_001_val_2.fq.gz"  >> ${OUT}  
    echo "gtf=/scratch/yz77862/liftoff/A188_liftoff_ABS_cds.gtf"  >> ${OUT}   
    echo " "  >> ${OUT}  
    echo "STAR \\"  >> ${OUT}    
    echo "--runMode alignReads \\"  >> ${OUT}  
    echo "--genomeDir \${index}  \\"  >> ${OUT}  
    echo "--twopassMode Basic  \\"  >> ${OUT}  
    echo "​--runThreadN \${thread} \\"  >> ${OUT}  
    echo "--readFilesIn \${read1} \${read2} \\"  >> ${OUT}  
    echo "--outSAMtype None \\"  >> ${OUT}  
    echo "--outFileNamePrefix ${INPUT} \\"  >> ${OUT}  
    echo "--outFilterScoreMin 50 \\" >> ${OUT}  
    echo "--outFilterMultimapNmax 10000" >> ${OUT}  
    echo "--sjdbGTFfile \${gtf}" >> ${OUT}  
    echo " "  >> ${OUT}
