SIM := irun
TOP := read_slow_write_fast


help:
	@echo 'build -> run -> clean'
#	@echo ${RTL_V}
#	@echo ${INCDIR}

all: clean build run verdi

build:
#	dos2unix ${RTL_V}
	${SIM} -elaborate  -l irun_elaborate.log  -noupdate   \
         -64bit -access +rwc -loadpli1 debpli:novas_pli_boot -sv -nowarn NONPRT -assert \
         -timescale '1ns/1fs'    \
         -ALLOWREDEFINITION \
         -sv \
         -f flist_sim.f \
         -top ${TOP}


run:
	${SIM} -R -64bit -loadpli1 debpli:novas_pli_boot \
	-input irun.tcl \
  -timescale '1ns/1fs'    


verdi:
	verdi -sv \
		    -f flist_sim.f \
				-top ${TOP} \
				-ssf ./${TOP}.fsdb &

.PHONY: clean
clean:
	@rm -fr *~ *.bak *.log *.key  *.diag INCA_libs *.vf
