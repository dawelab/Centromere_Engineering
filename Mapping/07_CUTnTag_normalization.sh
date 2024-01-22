###For the CUT&Tag data without any filtering
sample  neo4L tissue chip-antibody 10k 25k 50k 100k           
SRR22950215 #Neo4L-4 ear IgG 723254263 722600905 722386175 722278194
SRR22950216 #Neo4L-4 ear CENH3 581051874 580569878 580407535 580327399
SRR22950217 #Neo4L-3 ear IgG 687358213 686901336 686749483 686673071
SRR22950218 #Neo4L-3 ear CENH3 942272045 941773335 941607683 941525423
SRR22950219 #Neo4L-2 ear IgG 704962295 704395545 704211225 704118273
SRR22950220 #Neo4L-2 ear CENH3 974541314 973883964 973664226 973555914 
SRR22950221 #Neo4L-1 ear IgG 358161953 357825750 357714579 357658829
SRR22950222 #Neo4L-1 ear CENH3 1456479873 1456187847 1456089482 1456040354
yz252-2-CenH3 #Neo4L-1 seedling CENH3 101574552 101439889 101394196 101371293
yz252-7-CenH3 #Neo4L-1 seedling CENH3 50900023 50787288 50750479 50732484
yz252-7-IgG #Neo4L-1 seedling IgG 147019229 146773042 146690074 146648296 
yz252-8-CenH3 #Neo4L-1 seedling CENH3 49869648 49769149 49736612 49719798
yz253-2-CenH3 #Neo4L-1 seedling CENH3 35222253 35162524 35142742 35131946
yz253-3-CenH3 #Neo4L-1 seedling CENH3 103653263 103471981 103408818 103378203 
yz253-4-CenH3 #Neo4L-1 seedling CENH3 78615288 78471222 78422431 78398307
yz253-4-IgG #ABS-het seedling IgG 409417750 408879613 408701078 408612321
yz253-5-CenH3 #ABS-het seedling CENH3 54540551 54421166 54382655 54362414 
yz254-4-CenH3 #ABS-het seedling CENH3 45070578 44953748 44915840 44895507
yz254-4-IgG #ABS-het seedling ABS-het IgG 131611395 131337664 131244546 131197983

###For the CUT&Tag data with -q 20
SRR22950215 #Neo4L-4 ear IgG 248539055 248140385 248008184 247942052 
SRR22950216 #Neo4L-4 ear CENH3 161522079 161257851 161168047 161123027
SRR22950217 #Neo4L-3 ear IgG 215026602 214753310 214661951 214615397  
SRR22950218 #Neo4L-3 ear CENH3 289344971 289044139 288943606 288892934  
SRR22950219 #Neo4L-2 ear IgG 236490134 236154363 236043839 235988583 
SRR22950220 #Neo4L-2 ear CENH3 286343636 285964484 285835597 285772484 
SRR22950221 #Neo4L-1 ear IgG 130831272 130625486 130557020 130522698
SRR22950222 #Neo4L-1 ear CENH3 441620283 441459665 441407039 441380266
yz252-2-CenH3 #Neo4L-1 seedling CENH3 41098930 41023761 40998639 40986147 
yz252-7-CenH3 #Neo4L-1 seedling CENH3 19849084 19786526 19765830 19755992
yz252-7-IgG #Neo4L-1 seedling IgG 52031080 51892515 51846716 51822778 
yz252-8-CenH3 #Neo4L-1 seedling CENH3 17842441 17786556 17768921 17759411
yz253-2-CenH3 #Neo4L-1 seedling CENH3 13641615 13609733 13599265 13593107
yz253-3-CenH3 #Neo4L-1 seedling CENH3 28882378 28794074 28763929 28749367
yz253-4-CenH3 #Neo4L-1 seedling CENH3 24805869 24729588 24704358 24691886
yz253-4-IgG #ABS-het seedling IgG 110074241 109794073 109701845 109655864
yz253-5-CenH3 #ABS-het seedling CENH3 19314465 19247798 19226592 19215564
yz254-4-CenH3 #ABS-het seedling CENH3 19687456 19617764 19595672 19583715
yz254-4-IgG #ABS-het seedling ABS-het IgG 50904936 50746360 50689434 50662351




#################################################
#NO FILTERING
#################################################

mkdir -p /scratch/yz77862/CUTnTag_neo4Ls/output/enrich
out=/scratch/yz77862/CUTnTag_neo4Ls/output/enrich
cd /scratch/yz77862/CUTnTag_neo4Ls/output/ratio/BED 
#For the 10kb  window
paste SRR22950216_win_10k_genomecov.bed2 SRR22950215_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-4",".",(($4+1)/581051874)/(($8+1)/723254263)}' OFS="\t" > ${out}/SRR22950216_15_Neo4L_4_win_10k_enrich.bed
paste SRR22950218_win_10k_genomecov.bed2 SRR22950217_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-3",".",(($4+1)/942272045)/(($8+1)/687358213)}' OFS="\t" > ${out}/SRR22950218_17_Neo4L_3_win_10k_enrich.bed
paste SRR22950220_win_10k_genomecov.bed2 SRR22950219_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-2",".",(($4+1)/974541314)/(($8+1)/704962295)}' OFS="\t" > ${out}/SRR22950220_19_Neo4L_2_win_10k_enrich.bed
paste SRR22950222_win_10k_genomecov.bed2 SRR22950221_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-1",".",(($4+1)/1456479873)/(($8+1)/358161953)}' OFS="\t" > ${out}/SRR22950222_21_Neo4L_1_win_10k_enrich.bed
paste yz252-2-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/101574552)/(($8+1)/147019229)}' OFS="\t" > ${out}/YZ252-2_YZ25-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz252-7-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/50900023)/(($8+1)/147019229)}' OFS="\t" > ${out}/YZ252-7_YZ252-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz252-8-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/49869648)/(($8+1)/147019229)}' OFS="\t" > ${out}/YZ252-8_YZ252-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-2-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/35222253)/(($8+1)/409417750)}' OFS="\t" > ${out}/YZ253-2_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-3-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/103653263)/(($8+1)/409417750)}' OFS="\t" > ${out}/YZ253-3_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-4-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/78615288)/(($8+1)/409417750)}' OFS="\t" > ${out}/YZ253-4_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-5-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/54540551)/(($8+1)/409417750)}' OFS="\t" > ${out}/YZ253-5_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz254-4-CenH3_win_10k_genomecov.bed2 yz254-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"ABS_het",".",(($4+1)/45070578)/(($8+1)/131611395)}' OFS="\t" > ${out}/YZ254-4_YZ254-4_Neo4L_1_win_10k_enrich.bed


#For the 25kb  window
paste SRR22950216_win_25k_genomecov.bed2 SRR22950215_win_25k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-4",".",(($4+1)/580569878)/(($8+1)/722600905)}' OFS="\t" > ${out}/SRR22950216_15_Neo4L_4_win_25k_enrich.bed
paste SRR22950218_win_25k_genomecov.bed2 SRR22950217_win_25k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-3",".",(($4+1)/941773335)/(($8+1)/686901336)}' OFS="\t" > ${out}/SRR22950218_17_Neo4L_3_win_25k_enrich.bed
paste SRR22950220_win_25k_genomecov.bed2 SRR22950219_win_25k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-2",".",(($4+1)/973883964)/(($8+1)/704395545)}' OFS="\t" > ${out}/SRR22950220_19_Neo4L_2_win_25k_enrich.bed
paste SRR22950222_win_25k_genomecov.bed2 SRR22950221_win_25k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-1",".",(($4+1)/1456187847)/(($8+1)/357825750)}' OFS="\t" > ${out}/SRR22950222_21_Neo4L_1_win_25k_enrich.bed
paste yz252-2-CenH3_win_25k_genomecov.bed2 yz252-7-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/101439889)/(($8+1)/146773042)}' OFS="\t" > ${out}/YZ252-2_YZ25-7_Neo4L_1_gen2_win_25k_enrich.bed
paste yz252-7-CenH3_win_25k_genomecov.bed2 yz252-7-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/50787288)/(($8+1)/146773042)}' OFS="\t" > ${out}/YZ252-7_YZ252-7_Neo4L_1_gen2_win_25k_enrich.bed
paste yz252-8-CenH3_win_25k_genomecov.bed2 yz252-7-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/49769149)/(($8+1)/146773042)}' OFS="\t" > ${out}/YZ252-8_YZ252-7_Neo4L_1_gen2_win_25k_enrich.bed
paste yz253-2-CenH3_win_25k_genomecov.bed2 yz253-4-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/35162524)/(($8+1)/408879613)}' OFS="\t" > ${out}/YZ253-2_YZ253-4_Neo4L_1_gen2_win_25k_enrich.bed
paste yz253-3-CenH3_win_25k_genomecov.bed2 yz253-4-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/103471981)/(($8+1)/408879613)}' OFS="\t" > ${out}/YZ253-3_YZ253-4_Neo4L_1_gen2_win_25k_enrich.bed
paste yz253-4-CenH3_win_25k_genomecov.bed2 yz253-4-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/78471222)/(($8+1)/408879613)}' OFS="\t" > ${out}/YZ253-4_YZ253-4_Neo4L_1_gen2_win_25k_enrich.bed
paste yz253-5-CenH3_win_25k_genomecov.bed2 yz253-4-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/54421166)/(($8+1)/408879613)}' OFS="\t" > ${out}/YZ253-5_YZ253-4_Neo4L_1_gen2_win_25k_enrich.bed
paste yz254-4-CenH3_win_25k_genomecov.bed2 yz254-4-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"ABS_het",".",(($4+1)/44953748)/(($8+1)/131337664)}' OFS="\t" > ${out}/YZ254-4_YZ254-4_Neo4L_1_win_25k_enrich.bed

#For the 50kb  window
paste SRR22950216_win_10k_genomecov.bed2 SRR22950215_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-4",".",(($4+1)/580407535)/(($8+1)/722386175)}' OFS="\t" > ${out}/SRR22950216_15_Neo4L_4_win_10k_enrich.bed
paste SRR22950218_win_10k_genomecov.bed2 SRR22950217_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-3",".",(($4+1)/941607683)/(($8+1)/686749483)}' OFS="\t" > ${out}/SRR22950218_17_Neo4L_3_win_10k_enrich.bed
paste SRR22950220_win_10k_genomecov.bed2 SRR22950219_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-2",".",(($4+1)/973664226)/(($8+1)/704211225)}' OFS="\t" > ${out}/SRR22950220_19_Neo4L_2_win_10k_enrich.bed
paste SRR22950222_win_10k_genomecov.bed2 SRR22950221_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-1",".",(($4+1)/1456089482)/(($8+1)/357714579)}' OFS="\t" > ${out}/SRR22950222_21_Neo4L_1_win_10k_enrich.bed
paste yz252-2-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/101394196)/(($8+1)/146690074)}' OFS="\t" > ${out}/YZ252-2_YZ25-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz252-7-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/50750479)/(($8+1)/146690074)}' OFS="\t" > ${out}/YZ252-7_YZ252-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz252-8-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/49736612)/(($8+1)/146690074)}' OFS="\t" > ${out}/YZ252-8_YZ252-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-2-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/35142742)/(($8+1)/408701078)}' OFS="\t" > ${out}/YZ253-2_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-3-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/103408818)/(($8+1)/408701078)}' OFS="\t" > ${out}/YZ253-3_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-4-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/78422431)/(($8+1)/408701078)}' OFS="\t" > ${out}/YZ253-4_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-5-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/54382655)/(($8+1)/408701078)}' OFS="\t" > ${out}/YZ253-5_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz254-4-CenH3_win_10k_genomecov.bed2 yz254-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"ABS_het",".",(($4+1)/44915840)/(($8+1)/131244546)}' OFS="\t" > ${out}/YZ254-4_YZ254-4_Neo4L_1_win_10k_enrich.bed

#For the 100kb  window
paste SRR22950216_win_10k_genomecov.bed2 SRR22950215_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-4",".",(($4+1)/580327399)/(($8+1)/722278194)}' OFS="\t" > ${out}/SRR22950216_15_Neo4L_4_win_10k_enrich.bed
paste SRR22950218_win_10k_genomecov.bed2 SRR22950217_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-3",".",(($4+1)/941525423)/(($8+1)/686673071)}' OFS="\t" > ${out}/SRR22950218_17_Neo4L_3_win_10k_enrich.bed
paste SRR22950220_win_10k_genomecov.bed2 SRR22950219_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-2",".",(($4+1)/973555914)/(($8+1)/704118273)}' OFS="\t" > ${out}/SRR22950220_19_Neo4L_2_win_10k_enrich.bed
paste SRR22950222_win_10k_genomecov.bed2 SRR22950221_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-1",".",(($4+1)/1456040354)/(($8+1)/357658829)}' OFS="\t" > ${out}/SRR22950222_21_Neo4L_1_win_10k_enrich.bed
paste yz252-2-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/101371293)/(($8+1)/146648296)}' OFS="\t" > ${out}/YZ252-2_YZ25-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz252-7-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/50732484)/(($8+1)/146648296)}' OFS="\t" > ${out}/YZ252-7_YZ252-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz252-8-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/49719798)/(($8+1)/146648296)}' OFS="\t" > ${out}/YZ252-8_YZ252-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-2-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/35131946)/(($8+1)/408612321)}' OFS="\t" > ${out}/YZ253-2_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-3-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/103378203)/(($8+1)/408612321)}' OFS="\t" > ${out}/YZ253-3_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-4-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/78398307)/(($8+1)/408612321)}' OFS="\t" > ${out}/YZ253-4_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-5-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/54362414)/(($8+1)/408612321)}' OFS="\t" > ${out}/YZ253-5_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz254-4-CenH3_win_10k_genomecov.bed2 yz254-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"ABS_het",".",(($4+1)/44895507)/(($8+1)/131197983)}' OFS="\t" > ${out}/YZ254-4_YZ254-4_Neo4L_1_win_10k_enrich.bed

#################################################
#Q20 filtering
#################################################
out=/scratch/yz77862/CUTnTag_neo4Ls/output/enrich
cd /scratch/yz77862/CUTnTag_neo4Ls/output/ratio/BEDQ20
#For the 10kb  window
paste SRR22950216_win_10k_genomecov.bed2 SRR22950215_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-4",".",(($4+1)/581051874)/(($8+1)/723254263)}' OFS="\t" > ${out}/SRR22950216_15_Neo4L_4_win_10k_enrich.bed
paste SRR22950218_win_10k_genomecov.bed2 SRR22950217_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-3",".",(($4+1)/942272045)/(($8+1)/687358213)}' OFS="\t" > ${out}/SRR22950218_17_Neo4L_3_win_10k_enrich.bed
paste SRR22950220_win_10k_genomecov.bed2 SRR22950219_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-2",".",(($4+1)/974541314)/(($8+1)/704962295)}' OFS="\t" > ${out}/SRR22950220_19_Neo4L_2_win_10k_enrich.bed
paste SRR22950222_win_10k_genomecov.bed2 SRR22950221_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-1",".",(($4+1)/1456479873)/(($8+1)/358161953)}' OFS="\t" > ${out}/SRR22950222_21_Neo4L_1_win_10k_enrich.bed
paste yz252-2-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/101574552)/(($8+1)/147019229)}' OFS="\t" > ${out}/YZ252-2_YZ25-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz252-7-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/50900023)/(($8+1)/147019229)}' OFS="\t" > ${out}/YZ252-7_YZ252-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz252-8-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/49869648)/(($8+1)/147019229)}' OFS="\t" > ${out}/YZ252-8_YZ252-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-2-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/35222253)/(($8+1)/409417750)}' OFS="\t" > ${out}/YZ253-2_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-3-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/103653263)/(($8+1)/409417750)}' OFS="\t" > ${out}/YZ253-3_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-4-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/78615288)/(($8+1)/409417750)}' OFS="\t" > ${out}/YZ253-4_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-5-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/54540551)/(($8+1)/409417750)}' OFS="\t" > ${out}/YZ253-5_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz254-4-CenH3_win_10k_genomecov.bed2 yz254-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"ABS_het",".",(($4+1)/45070578)/(($8+1)/131611395)}' OFS="\t" > ${out}/YZ254-4_YZ254-4_Neo4L_1_win_10k_enrich.bed


#For the 25kb  window
paste SRR22950216_win_25k_genomecov.bed2 SRR22950215_win_25k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-4",".",(($4+1)/580569878)/(($8+1)/722600905)}' OFS="\t" > ${out}/SRR22950216_15_Neo4L_4_win_25k_enrich.bed
paste SRR22950218_win_25k_genomecov.bed2 SRR22950217_win_25k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-3",".",(($4+1)/941773335)/(($8+1)/686901336)}' OFS="\t" > ${out}/SRR22950218_17_Neo4L_3_win_25k_enrich.bed
paste SRR22950220_win_25k_genomecov.bed2 SRR22950219_win_25k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-2",".",(($4+1)/973883964)/(($8+1)/704395545)}' OFS="\t" > ${out}/SRR22950220_19_Neo4L_2_win_25k_enrich.bed
paste SRR22950222_win_25k_genomecov.bed2 SRR22950221_win_25k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-1",".",(($4+1)/1456187847)/(($8+1)/357825750)}' OFS="\t" > ${out}/SRR22950222_21_Neo4L_1_win_25k_enrich.bed
paste yz252-2-CenH3_win_25k_genomecov.bed2 yz252-7-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/101439889)/(($8+1)/146773042)}' OFS="\t" > ${out}/YZ252-2_YZ25-7_Neo4L_1_gen2_win_25k_enrich.bed
paste yz252-7-CenH3_win_25k_genomecov.bed2 yz252-7-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/50787288)/(($8+1)/146773042)}' OFS="\t" > ${out}/YZ252-7_YZ252-7_Neo4L_1_gen2_win_25k_enrich.bed
paste yz252-8-CenH3_win_25k_genomecov.bed2 yz252-7-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/49769149)/(($8+1)/146773042)}' OFS="\t" > ${out}/YZ252-8_YZ252-7_Neo4L_1_gen2_win_25k_enrich.bed
paste yz253-2-CenH3_win_25k_genomecov.bed2 yz253-4-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/35162524)/(($8+1)/408879613)}' OFS="\t" > ${out}/YZ253-2_YZ253-4_Neo4L_1_gen2_win_25k_enrich.bed
paste yz253-3-CenH3_win_25k_genomecov.bed2 yz253-4-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/103471981)/(($8+1)/408879613)}' OFS="\t" > ${out}/YZ253-3_YZ253-4_Neo4L_1_gen2_win_25k_enrich.bed
paste yz253-4-CenH3_win_25k_genomecov.bed2 yz253-4-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/78471222)/(($8+1)/408879613)}' OFS="\t" > ${out}/YZ253-4_YZ253-4_Neo4L_1_gen2_win_25k_enrich.bed
paste yz253-5-CenH3_win_25k_genomecov.bed2 yz253-4-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/54421166)/(($8+1)/408879613)}' OFS="\t" > ${out}/YZ253-5_YZ253-4_Neo4L_1_gen2_win_25k_enrich.bed
paste yz254-4-CenH3_win_25k_genomecov.bed2 yz254-4-IgG_win_25k_genomecov.bed2 | awk '{print $1,$2,$3,"ABS_het",".",(($4+1)/44953748)/(($8+1)/131337664)}' OFS="\t" > ${out}/YZ254-4_YZ254-4_Neo4L_1_win_25k_enrich.bed

#For the 50kb  window
paste SRR22950216_win_10k_genomecov.bed2 SRR22950215_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-4",".",(($4+1)/580407535)/(($8+1)/722386175)}' OFS="\t" > ${out}/SRR22950216_15_Neo4L_4_win_10k_enrich.bed
paste SRR22950218_win_10k_genomecov.bed2 SRR22950217_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-3",".",(($4+1)/941607683)/(($8+1)/686749483)}' OFS="\t" > ${out}/SRR22950218_17_Neo4L_3_win_10k_enrich.bed
paste SRR22950220_win_10k_genomecov.bed2 SRR22950219_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-2",".",(($4+1)/973664226)/(($8+1)/704211225)}' OFS="\t" > ${out}/SRR22950220_19_Neo4L_2_win_10k_enrich.bed
paste SRR22950222_win_10k_genomecov.bed2 SRR22950221_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-1",".",(($4+1)/1456089482)/(($8+1)/357714579)}' OFS="\t" > ${out}/SRR22950222_21_Neo4L_1_win_10k_enrich.bed
paste yz252-2-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/101394196)/(($8+1)/146690074)}' OFS="\t" > ${out}/YZ252-2_YZ25-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz252-7-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/50750479)/(($8+1)/146690074)}' OFS="\t" > ${out}/YZ252-7_YZ252-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz252-8-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/49736612)/(($8+1)/146690074)}' OFS="\t" > ${out}/YZ252-8_YZ252-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-2-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/35142742)/(($8+1)/408701078)}' OFS="\t" > ${out}/YZ253-2_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-3-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/103408818)/(($8+1)/408701078)}' OFS="\t" > ${out}/YZ253-3_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-4-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/78422431)/(($8+1)/408701078)}' OFS="\t" > ${out}/YZ253-4_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-5-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/54382655)/(($8+1)/408701078)}' OFS="\t" > ${out}/YZ253-5_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz254-4-CenH3_win_10k_genomecov.bed2 yz254-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"ABS_het",".",(($4+1)/44915840)/(($8+1)/131244546)}' OFS="\t" > ${out}/YZ254-4_YZ254-4_Neo4L_1_win_10k_enrich.bed

#For the 100kb  window
paste SRR22950216_win_10k_genomecov.bed2 SRR22950215_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-4",".",(($4+1)/580327399)/(($8+1)/722278194)}' OFS="\t" > ${out}/SRR22950216_15_Neo4L_4_win_10k_enrich.bed
paste SRR22950218_win_10k_genomecov.bed2 SRR22950217_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-3",".",(($4+1)/941525423)/(($8+1)/686673071)}' OFS="\t" > ${out}/SRR22950218_17_Neo4L_3_win_10k_enrich.bed
paste SRR22950220_win_10k_genomecov.bed2 SRR22950219_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-2",".",(($4+1)/973555914)/(($8+1)/704118273)}' OFS="\t" > ${out}/SRR22950220_19_Neo4L_2_win_10k_enrich.bed
paste SRR22950222_win_10k_genomecov.bed2 SRR22950221_win_10k_genomecov.bed2  | awk '{print $1,$2,$3,"Neo4L-1",".",(($4+1)/1456040354)/(($8+1)/357658829)}' OFS="\t" > ${out}/SRR22950222_21_Neo4L_1_win_10k_enrich.bed
paste yz252-2-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/101371293)/(($8+1)/146648296)}' OFS="\t" > ${out}/YZ252-2_YZ25-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz252-7-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/50732484)/(($8+1)/146648296)}' OFS="\t" > ${out}/YZ252-7_YZ252-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz252-8-CenH3_win_10k_genomecov.bed2 yz252-7-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen2",".",(($4+1)/49719798)/(($8+1)/146648296)}' OFS="\t" > ${out}/YZ252-8_YZ252-7_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-2-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/35131946)/(($8+1)/408612321)}' OFS="\t" > ${out}/YZ253-2_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-3-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/103378203)/(($8+1)/408612321)}' OFS="\t" > ${out}/YZ253-3_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-4-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/78398307)/(($8+1)/408612321)}' OFS="\t" > ${out}/YZ253-4_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz253-5-CenH3_win_10k_genomecov.bed2 yz253-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"Neo4L-1_gen5",".",(($4+1)/54362414)/(($8+1)/408612321)}' OFS="\t" > ${out}/YZ253-5_YZ253-4_Neo4L_1_gen2_win_10k_enrich.bed
paste yz254-4-CenH3_win_10k_genomecov.bed2 yz254-4-IgG_win_10k_genomecov.bed2 | awk '{print $1,$2,$3,"ABS_het",".",(($4+1)/44895507)/(($8+1)/131197983)}' OFS="\t" > ${out}/YZ254-4_YZ254-4_Neo4L_1_win_10k_enrich.bed

