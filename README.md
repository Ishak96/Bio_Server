# Bio_Server
fonctionnement d'un centre de données sur les enérgies rebouvelabes, tests de surchage de la cpu, instalation d'un hebergeur de site web..

## université de cergy pontoise
## ENSEA
### AYAD Ishak

stage de fin d'année licence 3

#### To download the project
```
	git clone https://www.github.com/ishak96/Bio_Server
```
#### Then go to the directory
```
	cd Bio_server
```

#### to test the ucp usage go to
```
	cd tests
```

#### to generate the log and data files
```
	sh cpu_usage.sh <per time> <repetitions>
```

#### application manager allow us to generate a charge for the cpu
```
$./app_manager.sh
[*.c | script] [e|s] [run|kill] [Integer] [Integer]
Enter your app: [app] [mode] [apply] [repeat] [interval]: ...
```
#### app
1. dd : "dd if=/dev/zero of=/dev/null"
 ⋅⋅* /dev/zero provides an endless stream of zero bytes when read. This function is provided by the kernel and does not require allocating memory. All writes to /dev/null are dropped silently.
 ..* Duplicate data (dd) from input file (if) of /dev/zero (virtual limitless supply of 0's) into output file (of) of /dev/null (virtual sinkhole) using blocks of 500M size (bs = block size) and repeat this (count) just once (1)
2. rand : "while true; do echo $((13**99)) 1> /dev/urandom 2>&1; done"
 ..* 100% load on a Linux machine.
 ..* Via a while ( un ou plusieurs CPU ).
3. one_full : "while true; do true; done"
 ..* Via a while usage of 50% of the cpu
4. cat : "cat /dev/urandom > /dev/null"
 ..* Via a cat command.
 ..* While there are your normal, printable ASCII characters that are sent back and forth on a terminal, there are also many unprintable characters that are used for the system to communicate with the terminal. For example, if a program sends the character 0x07 ("ASCII Bell character"), your terminal should beep.

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

copy file from the server to your machine using sftp
```
$ sftp user_name@server_name
Connected to server_name
sftp> dir
file1 file2 file3
sftp> pwd
Remot worjing directory: /home/etis/tests
sftp> get file2
Fetching /home/etis/tests/file2 to file2
/home/etis/tests/file2
sftp> bye
```
