#!/bin/bash
#SBATCH --job-name=liftoff                
#SBATCH --partition=batch		                            
#SBATCH --ntasks=1			                            
#SBATCH --cpus-per-task=4		                       
#SBATCH --mem=150gb			                               
#SBATCH --time=168:00:00  		                          
#SBATCH --output=liftoff.out			  
#SBATCH --error=liftoff.err

cd /scratch/yz77862/liftoff
ml Liftoff/1.6.3

B73_genome=Zm-B73-REFERENCE-NAM-5.0.fa
Mo17_genome=Zm-Mo17-REFERENCE-CAU-2.0.fa
B73_anno=Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gff3
Mo17_anno=Zm-Mo17-REFERENCE-CAU-2.0_Zm00014ba.gff3
A188_genome=Zm-A188-REFERENCE-KSU-1.0.fa
A188_anno=Zm-A188-REFERENCE-KSU-1.0_Zm00056aa.1.gff3

ABS=/scratch/yz77862/ABS_PacBio_version1/AbsGenomePBHIFI_version_1.fa

####Reannotatinng A188, B73 and Mo17 genome to acquire the annotation accuracy 
liftoff ${B73_genome} ${Mo17_genome} -g ${Mo17_anno} -cds -copies  -o B73_liftoff_reMo17.gff3
liftoff  ${Mo17_genome} ${B73_genome} -g ${B73_anno} -cds -copies -o Mo17_liftoff_reB73.gff3
liftoff  ${Mo17_genome} ${A188_genome} -g ${A188_anno} -cds -copies -o Mo17_liftoff_reB73.gff3

####Annotate ABSGenome_version_1 genome with Mo17, B73 and A188 genome 
liftoff ${ABS} ${Mo17_genome} -g ${Mo17_anno} -cds -copies -o Mo17_liftoff_ABSGenome.gff3
liftoff ${ABS} ${B73_genome} -g ${B73_anno} -cds -copies -o B73_liftoff_ABSGenome.gff3
liftoff ${ABS} ${A188_genome} -g ${A188_anno} -cds -copies -o A188_liftoff_ABSGenome.gff3
