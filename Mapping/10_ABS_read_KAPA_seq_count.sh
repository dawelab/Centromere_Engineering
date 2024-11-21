wk '$3>=95' J721_R1_001_val_1_blast_diABS_result.xls | awk '{print $1,$7,$8}' OFS="\t" | uniq | sort -b -k1,1 -k2,2n -k3,3n | bedtools merge | wc -l

for file in *.fa; do 
echo "$(basename "$file") $(( $(wc -l < "$file") / 2 ))"
done > read_countsummary.txt

for file in *.xls; do
echo "$(basename "$file") $(awk '$3>=95' "'$file'" | awk '{print $1,$7,$8}' OFS="\t" | uniq | sort -b -k1,1 -k2,2n -k3,3n | bedtools merge | awk '$3-$2>50' | wc -l)" done > ABS_countsummary.txt
