ml BEDTools
awk '$3>=95' J721_R1_001_val_1_blast_diABS_result.xls | awk '{print $1,$7,$8}' OFS="\t" | uniq | sort -b -k1,1 -k2,2n -k3,3n | bedtools merge | wc -l
##Calculate the total read count from fasta
for file in *.fa; do 
echo "$(basename "$file") $(( $(wc -l < "$file") / 2 ))"
done > read_countsummary.txt
##Calculate the ABS containing reads from blast -outfmt 6 generated *xls files
for file in *.xls; do
  if [ -f "$file" ]; then
    count=$(awk '$3 >= 95' "$file" | \
      awk '{print $1, $7, $8}' OFS="\t" | \
      uniq | \
      sort -b -k1,1 -k2,2n -k3,3n | \
      bedtools merge | \
      awk '$3 - $2 > 50' | \
      wc -l)
    echo "$(basename "$file") $count"
  else
    echo "Skipping $file: Not a valid file."
  fi
done > ABS_countsummary.txt
