Generated by ChatGpt:

**Reshaping the Maize Karyotype Using Synthetic Centromeres**


This repository contains data, code, and resources supporting the paper "Reshaping the maize karyotype using synthetic centromeres" by Yibing Zeng et al. We demonstrate the feasibility of engineering functional synthetic centromeres in maize and their accurate segregation throughout plant development, including meiosis. By tethering the key centromere protein CENP-A/CENH3 to synthetic repeat sequences, we generated neochromosomes derived from chromosome 4 and characterized their structural and functional stability. Notably, we recovered and analyzed a truncated 4a chromosome paired with a complementing 4b neochromosome, which, when homozygous, supports normal plant growth, meiosis, and gene expression. This work establishes a foundation for centromere engineering to reshape plant karyotypes and accelerate artificial chromosome development. The repository includes sequencing data, methylation and gene expression analyses, and all custom scripts used in this study.

Key highlights:
*The structure of ABS4 and its annotation.

<img width="544" alt="image" src="https://github.com/user-attachments/assets/b33a219c-5152-42a4-83ed-9c4e7c96ea4e" />


*Generation of synthetic centromeres using LexA-CENH3 tethering and created neochromosomes.

<img width="480" alt="image" src="https://github.com/user-attachments/assets/1cbfaa84-71aa-4c5c-bc9b-260b0d1aafca" />


*Characterization of neochromosomes via CUT&Tag, RNA-seq, and EM-seq.

<img width="432" alt="image" src="https://github.com/user-attachments/assets/c06d50ff-87c0-44c6-acd6-40852df80354" />



*Recovery of stable, functional chromosome pairs in maize.

<img width="299" alt="image" src="https://github.com/user-attachments/assets/d5f9edba-5b34-44ac-a9e6-717764578a32" />


*Data Availability: Sequencing data are deposited in NCBI BioProject PRJNA874319. The ABS4 genome assembly and annotations are available on Zenodo.



**Repository Structure**


1. Genome Assembly
   
Scripts for assembling PacBio HiFi reads using Hifiasm and scaffolding with RagTag.

Tools for detecting LexO binding sites and annotation with Liftoff and EDTA.

2. CUT&Tag Analysis

Pipelines for mapping CENH3 reads with BWA-mem.

Code for window-based enrichment calculations and visualization using BEDTools and ggplot2.

3. RNA-Seq Analysis
   
Scripts for trimming adapters, alignment with STAR, and expression quantification using FeatureCounts.

Differential expression analysis via DESeq2.

4. DNA Methylation Analysis
   
EM-seq pipelines for methylation calling with BS-Seeker2.

Tools for calculating and visualizing methylation across genomic windows.

5. Visualization & Integration
   
Final scripts for generating figures integrating gene expression, methylation, and centromere data.

Data Availability

NCBI BioProject: PRJNA874319

ABS4 Genome: Zenodo

Dependencies

**Tools**: Hifiasm, RagTag, BWA, BEDTools, STAR, DESeq2, ggplot2, BS-Seeker2, CGmapTools.

**Languages**: Python, R, Bash.

*Code: All scripts and analysis pipelines are available in this repository.



