# Bio_Server
fonctionnement d'un centre de données sur les enérgies rebouvelabes, tests de surchage de la cpu, instalation d'un hebergeur de site web..

## université de cergy pontoise
## ENSEA
### AYAD Ishak

stage de fin d'année licence 3

To download the project
```
	git clone https://www.github.com/ishak96/Bio_Server
```
Then go to the directory
```
	cd Bio_server
```

to test the ucp usage go to
```
	cd tests
```

to generate the log and data files
```
	sh cpu_usage.sh <per time> <repetitions>
```

to get the physical cpu's usage
```
	gcc C_Prog/data_physical_cpu.c -o data_physical_cpu
  ./data_physical_cpu <number of pysical cpu's
```

how to install gnuplot
```
  $ sudo apt-get install gnuplot
```

plot the physical/logical cpu's data
```
  load 'plot_core_logic.p'
  load 'plot_core_physic.p'
```
