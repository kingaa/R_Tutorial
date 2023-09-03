default: index.html tutorial.R tutorial.html munging.R munging.html viz.R viz.html

fresh: clean .fresh

clean: .clean	
	$(RM) ChlorellaGrowth.csv

include rules.mk

