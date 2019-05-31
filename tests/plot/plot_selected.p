set key autotitle columnhead
set xrange [0:2900]
set yrange [0:120]
set tics font ", 25"
set key font ",20"
set ytics 10
set xtics 100
set xlabel "time (s)" font "Helvetica, 12"
set ylabel "% usage of cores" font "Helvetica, 12"
set title "CPU usage of glyphosate server's" font "Helvetica, 15"
set terminal png size 3000,1500;
set output 'core_glyphosate_cpu.png'
do for [i=1:2] {
    set style line i linewidth 3
}
plot for[n=2:2] 'data_physical_cpu.dat' u 1:n with lines lw 4