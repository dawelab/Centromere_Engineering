#Extract ABS region
for i in KD4315-2 KD4315-4 KD4315-5 KD4315-8 yz306-2 yz306-3 yz306-5 yz306-6;do
awk '$1=="chr4_RagTag"' ${i}.CGmap | awk '$4=="CG"' | awk '$3>=189007108' | awk '$3<=189589028' > ${i}_chr4_CG_ABS.CGmap
awk '$1=="chr4_RagTag"' ${i}.CGmap | awk '$4=="CHG"' | awk '$3>=189007108' | awk '$3<=189589028' > ${i}_chr4_CHG_ABS.CGmap
awk '$1=="chr4_RagTag"' ${i}.CGmap | awk '$4=="CHH"' | awk '$3>=189007108' | awk '$3<=189589028' > ${i}_chr4_CHH_ABS.CGmap
done
##500k upstream ABS
for i in KD4315-2 KD4315-4 KD4315-5 KD4315-8 yz306-2 yz306-3 yz306-5 yz306-6;do
awk '$1=="chr4_RagTag"' ${i}.CGmap | awk '$4=="CG"' | awk '$3>=188507108' | awk '$3<=189007108' > ${i}_chr4_CG_ABS_up500.CGmap
awk '$1=="chr4_RagTag"' ${i}.CGmap | awk '$4=="CHG"' | awk '$3>=188507108' | awk '$3<=189007108' > ${i}_chr4_CHG_ABS_up500.CGmap
awk '$1=="chr4_RagTag"' ${i}.CGmap | awk '$4=="CHH"' | awk '$3>=188507108' | awk '$3<=189007108' > ${i}_chr4_CHH_ABS_up500.CGmap
done
##500k downstream ABS
for i in KD4315-2 KD4315-4 KD4315-5 KD4315-8 yz306-2 yz306-3 yz306-5 yz306-6;do
awk '$1=="chr4_RagTag"' ${i}.CGmap | awk '$4=="CG"' | awk '$3>=189007108' | awk '$3<=189507108' > ${i}_chr4_CG_ABS_down500.CGmap
awk '$1=="chr4_RagTag"' ${i}.CGmap | awk '$4=="CHG"' | awk '$3>=189007108' | awk '$3<=189507108' > ${i}_chr4_CHG_ABS_down500.CGmap
awk '$1=="chr4_RagTag"' ${i}.CGmap | awk '$4=="CHH"' | awk '$3>=189007108' | awk '$3<=189507108' > ${i}_chr4_CHH_ABS_down500.CGmap
done
##500k around  ABS
for i in KD4315-2 KD4315-4 KD4315-5 KD4315-8 yz306-2 yz306-3 yz306-5 yz306-6;do
awk '$1=="chr4_RagTag"' ${i}.CGmap | awk '$4=="CG"' | awk '$3>=188507108' | awk '$3<=189507108' > ${i}_chr4_CG_ABS_near500.CGmap
awk '$1=="chr4_RagTag"' ${i}.CGmap | awk '$4=="CHG"' | awk '$3>=188507108' | awk '$3<=189507108' > ${i}_chr4_CHG_ABS_near500.CGmap
awk '$1=="chr4_RagTag"' ${i}.CGmap | awk '$4=="CHH"' | awk '$3>=188507108' | awk '$3<=189507108' > ${i}_chr4_CHH_ABS_near500.CGmap
done
for CONTEXT in CG CHG CHH;do
cgmaptools mmbin -c 1 -B 10000 -l KD4315-2_chr4_${CONTEXT}_ABS.CGmap,KD4315-4_chr4_${CONTEXT}_ABS.CGmap,KD4315-5_chr4_${CONTEXT}_ABS.CGmap,KD4315-8_chr4_${CONTEXT}_ABS.CGmap,yz306-2_chr4_${CONTEXT}_ABS.CGmap,yz306-3_chr4_${CONTEXT}_ABS.CGmap,yz306-5_chr4_${CONTEXT}_ABS.CGmap,yz306-6_chr4_${CONTEXT}_ABS.CGmap  > chr4_${CONTEXT}_ABS.mmbin.tab 
cgmaptools heatmap -i chr4_${CONTEXT}_ABS.mmbin.tab  -c -o cluster.pdf -f pdf
done

for CONTEXT in CG CHG CHH;do
cgmaptools mmbin -c 1 -B 10000 -l KD4315-2_chr4_${CONTEXT}_ABS_up500.CGmap,KD4315-4_chr4_${CONTEXT}_ABS_up500.CGmap,KD4315-5_chr4_${CONTEXT}_ABS_up500.CGmap,KD4315-6_chr4_${CONTEXT}_ABS_up500.CGmap,yz306-2_chr4_${CONTEXT}_ABS_up500.CGmap,yz306-3_chr4_${CONTEXT}_ABS_up500.CGmap,yz306-5_chr4_${CONTEXT}_ABS_up500.CGmap,yz306-6_chr4_${CONTEXT}_ABS_up500.CGmap  > chr4_${CONTEXT}_ABS_up500.mmbin.tab 
cgmaptools heatmap -i chr4_${CONTEXT}_ABS.mmbin.tab  -c -o cluster.pdf -f pdf
done
