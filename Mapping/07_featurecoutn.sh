gtf=/scratch/yz77862/liftoff/A188_liftoff_ABS_cds.gtf
/home/yz77862/apps/subread-1.6.0-Linux-x86_64/bin/featureCounts  -a ${gtf} -o L3_exon_count.counts *bam -M -f -t gene
