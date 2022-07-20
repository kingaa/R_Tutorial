default: index.html tutorial.html tutorial.R munging.html munging.R viz.html viz.R

fresh: clean .fresh

clean: .clean	
	$(RM) ChlorellaGrowth.csv

include rules.mk

