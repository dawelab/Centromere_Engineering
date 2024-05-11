


bedtools genomecov -ibam  \${BAMQ20}/KD4277_ABS.sorted_q20.bam -bg | awk '{print \$0,(\$3-\$2)*\$4}' OFS="\t" > \${genomecov}/KD4277_q20_genomecov.bed
bedtools intersect -wa -wb -a \${win_100k} -b \${genomecov}/KD4277_q20_genomecov.bed | bedtools groupby -c 8 -o sum > \${genomecov}/KD4277_win_100k_q20_genomecov.bed1
bedtools intersect -wa -wb -a \${win_100k} -b \${genomecov}/KD4277_q20_genomecov.bed -v | awk '{print \$1,\$2,\$3,0}' OFS="\t" > \${genomecov}/KD4277_win_100k_q20_genomecov.bed2 
cat \${genomecov}/KD4277_win_100k_q20_genomecov.bed1 \${genomecov}/KD4277_win_100k_q20_genomecov.bed2 | sort -b -k1,1 -k2,2n -k3,3n > \${genomecov}/KD4277_win_100k_q20_genomecov.bed 
rm \${genomecov}/KD4277_win_100k_q20_genomecov.bed1 \${genomecov}/KD4277_win_100k_q20_genomecov.bed2 
