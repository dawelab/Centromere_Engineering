kmc -v -k21 -m90 -t128 @../${name}_inputs/${name}_inputs.fofn ${name} ${name}_kmc
kmc_tools -t20 transform ${name} histogram ${name}_hist.txt
