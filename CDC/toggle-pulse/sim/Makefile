help:
	@echo 'build -> run -> clean'
#	@echo ${RTL_V}
#	@echo ${INCDIR}

all: clean build run

build:
#	dos2unix ${RTL_V}
	irun -elaborate  -l irun_elaborate.log  -noupdate   \
       -64bit -access +rwc -loadpli1 debpli:novas_pli_boot -sv -nowarn NONPRT -assert \
  	 	 -timescale '1ns/1fs'    \
       -ALLOWREDEFINITION \
       -sv \
       -f flist_sim.f  
		

       # -define _RTL_SIM__ -timescale '1ns/1fs'        \
       # -covtest ${testname} \
       # -coverage A \
       # -covdut tb \
       # -covworkdir ./cov_work\
       #

run:
	irun -R -64bit -loadpli1 debpli:novas_pli_boot \
	-input irun.tcl \
  -timescale '1ns/1fs'    \

simvision:
	simvision -64BIT -INPUT wave_signals_gxh.svcf  waves.shm

verdi:
	verdi -sv -f flist_sim.f -ssf ./top_tb.fsdb &

.PHONY: clean
clean:
	@rm -fr *~ *.bak *.log *.key  *.diag INCA_libs *.vf
