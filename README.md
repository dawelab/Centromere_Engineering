# **Reshaping the Maize Karyotype Using Synthetic Centromeres**

Generated by ChatGpt & revised by Yibing Zeng (EM-seq is mainly from Jonathan I. Gent):

Any script questions are welcome to email Yibing Zeng (yibing.zeng6@gmail.com).

This repository contains data, code, and resources supporting the paper "Reshaping the maize karyotype using synthetic centromeres" by Yibing Zeng et al. We demonstrate the feasibility of engineering functional synthetic centromeres in maize and their accurate segregation throughout plant development, including meiosis. By tethering the key centromere protein CENP-A/CENH3 to synthetic repeat sequences, we generated neochromosomes derived from chromosome 4 and characterized their structural and functional stability. Notably, we recovered and analyzed a truncated 4a chromosome paired with a complementing 4b neochromosome, which, when homozygous, supports normal plant growth, meiosis, and gene expression. This work establishes a foundation for centromere engineering to reshape plant karyotypes and accelerate artificial chromosome development. The repository includes sequencing data, methylation and gene expression analyses, and all custom scripts used in this study.

## **Key highlights && Repository Structure:**

### 1. The structure of ABS4 and its annotation.


<img width="544" alt="image" src="https://github.com/user-attachments/assets/b33a219c-5152-42a4-83ed-9c4e7c96ea4e" />

workflow:

step 1. The primary contigs of ABS4 inbred assembly is generated by hifiasm with `-l 0` parameter (`-l 0` is for homozygosity assumption). `-u` command enables postjoining the overlapping region but create assembly errors else where, som we disabled it here.
    
step 2. Misassembled (a contig is wrongly connected by (TAC)n repeats) and over-scaffold (ragtag did not distinguish heterozygosity region) are resolved by custom-scripts by removing overlapping cotigs with former contigs. ABS contigs are scaffolded by post joining overlapping regions with head to tail orientation.

step 3. Gene annotation is performed by Liftoff used A188 as a guide.

step 4. TE annotation is performed by `EDTA`, parameters selection refers to what Ou Shuju did for the maize pan genome assembly published by Hufford et.al (2021) .
   
step 5. The annotation of ABS and pACH25 are done by `blastn`.  

step 6. The visualization here used Karyotype package in R. The visualization in the main figure used customize script under mapping folder, it is way easier than you think: acquire the start and end position of the block you like (gene, TE or others) and used `geom_rect` to visualize each block. You can adjust rect position by assigning different heights (I used y to denote in the script). 


### 2. Generation of synthetic centromeres using LexA-CENH3 tethering and created neochromosomes.

<img width="480" alt="image" src="https://github.com/user-attachments/assets/1cbfaa84-71aa-4c5c-bc9b-260b0d1aafca" />

Low coverage illumina sequencing is used to estimate the polidy of chromosome 4 by following work flow:

step1: `bwa` index the W22 and mapped illumina seq to it;

step2: `bedtools makewindows` generated 100kb window; 

step3: `bedtools intersect -c` calculate the read count for each bin;

step4: The polidy estimation is done R by: `mutate(ploidy = 2 * (count / sum(count)) * length(count))`;

step5: Visualized it in R using ggplot2 with each dot represents an estimation of ploidy at 100kb window.

Here, we tested three different references: 1. ABS4 assembly where we first seed centromeres; 2. W22 genome where we kept backcrossing to neo4bs; 3. A distantly related but near perfect assembly --- Mo17. W22 yields the most consistent results. The code for reference testing can be found under mapping folding.

Even I called the object ploidy estimation here. But it is not ploidy, one chromosome can only have one ploidy but we have thousands of data points here. 


### 3. Characterization of neochromosomes via CUT&Tag, RNA-seq, and EM-seq.

<img width="432" alt="image" src="https://github.com/user-attachments/assets/c06d50ff-87c0-44c6-acd6-40852df80354" />

#### 3. 1. Cut & Tag Pipeline:
   
step1: `bwa` index the ABS4 inbred assembly and mapped illumina seq to it;

step2: `bedtools makewindows` generated 10kb window (Smaller bins help to see if CENH3 goes over gene); 

step3: `bedtools intersect -c` calculate the read count for each bin;

step4: The visualization is done by customize R script enabling color-blinding selection.

#### 3.2. RNA-seq Pipeline:

step1: `STAR` index the ABS4 inbred assembly and mapped illumina seq to it;

step2: `Featurecount` is used to calculate the read count for each exon 

step3: Gene read count is sum in R and DESeq is used to perform fold change, RLEs and DEG analysis.

step4: The visualization is done by customize R script. Putting two histograms in one plot only requires a scale factor to shirk or enlarge one distribution. Here is a trick, fix one distribution you like and scale the other one!


#### 3.3. EM-seq:

step1: EM-seq reads were trimmed of adapter sequence using `cutadapt`, `parameters -q 20 -a AGATCGGAAGAGC -A AGATCGGAAGAGC -O .`

step2:  Reads were aligned to each genome and methylation values were called using `BS-Seeker2 v.2.1.5`, parameters `-m 1 –aligner=bowtie2 -X 1000`

step3: The resulting files in CGmap format were processed using `CGmapTools v.1.2`. The replicates of ABS4 homozygous line and 4a(3) 4b(3) homozygous line were merged two by two using the `merge2` tool and the 100kb window methylation calculation done with the `mbin tool  -c 1, -B 100000`

step4: Results plotted with gpplot2 wrapped in tidyverse. 


### 4. Recovery of stable, functional chromosome pairs in maize.

<img width="299" alt="image" src="https://github.com/user-attachments/assets/d5f9edba-5b34-44ac-a9e6-717764578a32" />



## **Data Availability**

NCBI BioProject: PRJNA874319

ABS4 Genome: Zenodo

##Dependencies

**Tools**: Hifiasm, RagTag, BWA, BEDTools, STAR, DESeq2, ggplot2, BS-Seeker2, CGmapTools.

## **Languages**: R, Bash.

*Code: All scripts and analysis pipelines are available in this repository. Some other codes are included here for pre-analysis but not used in the analysis for the paper. e.g. (1. A single-end read simulation using customized R script to check the mapping performance of illumina reads (150nt) over repetitve region; 2. Calculate the proportion of ABS containing count for qualify control; 3. Illumina analysis for additional 14 Neo4bs screens (Named as Neo4ls before) containing SVs generated by Breakage-Fusion-Bridge Cycles)

*The code is organized by analysis type and codes with the same order indicates one is for the analysis and one is for visulization.



