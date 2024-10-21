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
    echo "#SBATCH --ntasks=1"   >> ${OUT}              
    echo "#SBATCH --cpus-per-task=18"   >> ${OUT}          
    echo "#SBATCH --mem=200G"   >> ${OUT}                  
    echo "#SBATCH --time=030:00:00"   >> ${OUT}             
    echo "#SBATCH --output=${INPUT}_fq_bam.out"   >> ${OUT}         
    echo "#SBATCH --error=${INPUT}_fq_bam.err"   >> ${OUT}         
    echo " "  >> ${OUT}  
    echo "ml STAR" >> ${OUT}  
    echo "cd /scratch/yz77862/mRNA/gene_guide/round1" >> ${OUT}
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
    echo "cd /scratch/yz77862/mRNA/gene_guide/round2"  >> ${OUT}
    echo " " >> ${OUT}
    echo "SJ=/scratch/yz77862/mRNA/gene_guide/round1/${INPUT}_STARpass1/SJ.out.tab"  >> ${OUT}
    echo "STAR \\"  >> ${OUT}
    echo "--genomeDir \${index} \\"  >> ${OUT}
    echo "--runThreadN \${thread} \\"  >> ${OUT}
    echo "--sjdbFileChrStartEnd \${SJ} \\"  >> ${OUT}
    echo "--runMode alignReads \\"  >> ${OUT}
    echo "--readFilesIn \${read1} \${read2}\\"  >> ${OUT}
    echo "--outSAMattributes All \\"  >> ${OUT}
    echo "--outSAMmapqUnique 10 \\"  >> ${OUT}
    echo "--outFilterMismatchNmax 3 \\"  >> ${OUT}
    echo "--outFileNamePrefix ${INPUT}_round-2 \\"  >> ${OUT}
    echo "--outBAMsortingThreadN 4 \\"  >> ${OUT}
    echo "--outSAMtype BAM SortedByCoordinate \\"  >> ${OUT}
    echo "--outFilterScoreMin 50 \\" >> ${OUT}  
    echo "--outFilterMultimapNmax 10000 \\" >> ${OUT}  
    echo "--outWigType bedGraph read1_5p"  >> ${OUT}
   # sbatch ${OUT}
done < <(cut -f1,2 ${list} | grep -v 'skip' | sort -u)
